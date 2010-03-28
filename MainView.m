//
//  MainView.m
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//

#import "MainView.h"
#import "TorrentModel.h"
#import <dispatch/dispatch.h>


@implementation MainView

#pragma mark initialistion
-  (void)awakeFromNib
{
	[rateModel setDelegate:self];

	// Set the target for the view change buttons
	for (NSInteger i = 0; i < [[views cells] count]; i++) {
		[[[views cells] objectAtIndex:i] setTarget:self];
		[[[views cells] objectAtIndex:i] setAction:@selector(viewChanged:)];
	}
	
	// Set up the View NSPredicates
	completeFilter = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
						{
							TorrentModel *t = evaluatedObject;
							if ([[t size] longLongValue] == [[t downloaded] longLongValue]) {
								return YES;
							} else {
								return NO;
							}
						}];
	incompleteFilter = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
						{
							TorrentModel *t = evaluatedObject;
							if ([[t size] longLongValue] == [[t downloaded] longLongValue]) {
								return NO;
							} else {
								return YES;
							}
						}];
	
	// Set up the contents of the throttle selection menus
	defaultDownThrottles = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
							[NSNumber numberWithInt:20],[NSNumber numberWithInt:50],[NSNumber numberWithInt:100],
							[NSNumber numberWithInt:200],[NSNumber numberWithInt:400],[NSNumber numberWithInt:0], nil];
	
	defaultUpThrottles = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
						  [NSNumber numberWithInt:10],[NSNumber numberWithInt:20],[NSNumber numberWithInt:40],
						  [NSNumber numberWithInt:0], nil];
	
	// Create pop-up menu of available columns 
	NSArray *headers = [torrentTable tableColumns];
	for (int i = 0; i < [headers count]; i++) {
		NSTableColumn *column = [headers objectAtIndex:i];
		if ([[[column headerCell] stringValue] length] > 0) {
			NSMenuItem *item = [[NSMenuItem new] initWithTitle:[[column headerCell] stringValue] action:nil keyEquivalent:@"" ];
			[item setTarget:self];
			[item setAction:@selector(changeColumnState:)];
			[column setIdentifier:[item title]];
			[headerSelectionMenu addItem:item];
		}
	}
	[self setColumnMenuStates];


	// Get the current state and start the update timer
	[self displayed];
}

#pragma mark UI control
- (void) updateThrottlePopup: (NSPopUpButton *) popup throttle: (NSInteger) throttle defaultValues: (NSArray *) defaultValues  {
	if ([popup indexOfItemWithTag:throttle] != -1) {
		[popup selectItemWithTag:throttle];
	} else {
		for (NSInteger i = 0; i < [popup numberOfItems]; i++) {
			NSNumber *tag = [NSNumber numberWithInt:[[popup itemAtIndex:i] tag]];
			if (![defaultValues containsObject:tag]) {
				[popup removeItemAtIndex:i];
				break;
			}
		}
		for (NSInteger i = 0; i < [popup numberOfItems]; i++) {
			NSInteger tag = [[popup itemAtIndex:i] tag];
			if (tag > throttle || tag == 0) {
				NSString *title = [NSString stringWithFormat:@"%d KB/s", throttle];
				[popup insertItemWithTitle:title atIndex:i];
				[[popup itemAtIndex:i] setTag:throttle];
				[popup selectItemWithTag:throttle];
				break;
			} 
		}
	}
}


#pragma mark data control
-(void)displayed
{
	[self updateRateModel];
	[self updateTorrentListModel];
	
	[timer invalidate];
	timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimer:) userInfo:nil repeats:TRUE];
}

-(void)hidden
{
	[timer invalidate];
	timer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(onTimer:) userInfo:nil repeats:TRUE];
}

- (void)updateRateModel
{
	[rateModel update];
}

- (void)updateTorrentListModel
{
	[torrentListModel update];
}


#pragma mark events
- (void)onTimer:(NSTimer *)timer
{
	[self updateTorrentListModel];
	[self updateRateModel];
}


- (void)windowWillClose:(NSNotification*)notification
{
	[self hidden];
}
   
   
- (IBAction)viewChanged:(id)sender
{
	NSString *newView = [NSString stringWithString:[[views selectedCell] title]];
	
	if ([newView isEqualToString:@"All"]) {
		[torrentListController setFilterPredicate:nil];
		[torrentTable setAutosaveName:@"org.shadowrealm.mrtorrent.All"];
	}
	if ([newView isEqualToString:@"Complete"]) {
		[torrentListController setFilterPredicate:completeFilter];
		[torrentTable setAutosaveName:@"org.shadowrealm.mrtorrent.Complete"];
	}
	if ([newView isEqualToString:@"Incomplete"]) {
		[torrentListController setFilterPredicate:incompleteFilter];
		[torrentTable setAutosaveName:@"org.shadowrealm.mrtorrent.Incomplete"];
	}
	
	[self setColumnMenuStates];
}

- (void)didUpdateRates
{
	[self updateThrottlePopup:upThrottlePopup throttle:[[rateModel upLimit] intValue] defaultValues:defaultUpThrottles];
	[self updateThrottlePopup:downThrottlePopup throttle:[[rateModel downLimit] intValue] defaultValues:defaultDownThrottles];
}

- (IBAction)upThrottleChanged:(id)sender
{
	NSInteger bytesPerSecond = [[upThrottlePopup selectedItem] tag];
	
	[rateModel setUpThrottle:bytesPerSecond];
}

- (IBAction)downThrottleChanged:(id)sender
{
	NSInteger bytesPerSecond = [[downThrottlePopup selectedItem] tag];
	
	[rateModel setDownThrottle:bytesPerSecond];
}



#pragma mark menu handling methods
- (IBAction)stopTorrent:(id)sender
{
	TorrentModel *torrent = [[torrentListController selectedObjects] objectAtIndex:0];

	if (torrent != nil) {
		[torrent stop];
		[torrentListModel update];
	}
}

- (IBAction)startTorrent:(id)sender
{
	TorrentModel *torrent = [[torrentListController selectedObjects] objectAtIndex:0];
	
	if (torrent != nil) {
		[torrent start];
		[torrentListModel update];
	}
}

- (IBAction)deleteTorrent:(id)sender
{
	TorrentModel *torrent = [[torrentListController selectedObjects] objectAtIndex:0];
	
	if (torrent != nil) {
		[torrent remove];
		[torrentListModel update];
	}
}

- (BOOL)validateMenuItem:(NSMenuItem *)item
{
	TorrentModel *torrent = nil;
	if ( [[torrentListController selectedObjects] count] > 0 ) {
		 torrent = [[torrentListController selectedObjects] objectAtIndex:0];
	}

	if ([item action] == @selector(stopTorrent:)) {
		return (torrent != nil && [torrent active]) ? YES : NO;
	}
	if ([item action] == @selector(startTorrent:)) {
		return (torrent != nil && ![torrent active]) ? YES : NO;
	}
	if ([item action] == @selector(deleteTorrent:)) {
		return (torrent != nil && ![torrent active]) ? YES : NO;
	} else {
		return YES;
	}
}

- (IBAction)changeColumnState:(id)sender
{
	if ([sender state]) {
		[[torrentTable tableColumnWithIdentifier:[sender title]] setHidden:YES];
		[sender setState:NSOffState];
	} else {
		[[torrentTable tableColumnWithIdentifier:[sender title]] setHidden:NO];
		[sender setState:NSOnState];
	}
}

- (void)setColumnMenuStates
{
	NSArray *items = [headerSelectionMenu itemArray];
	for (int item = 0; item < [items count]; item++) {
		NSMenuItem *menuItem = [items objectAtIndex:item];
		if ([[torrentTable tableColumnWithIdentifier:[menuItem title]] isHidden]) {
			[menuItem setState:NSOffState];
		} else {
			[menuItem setState:NSOnState];
		}

	}
}


@end
