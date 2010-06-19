//
//  MainView.m
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//

#import "MainController.h"
#import "TorrentModel.h"
#import "PreferenceController.h"
#import <dispatch/dispatch.h>


@implementation MainController

#pragma mark initialistion
-  (void)awakeFromNib
{
	[rateModel setDelegate:self];

	// Set the target for the filter change buttons
	for (NSInteger i = 0; i < [[filters cells] count]; i++) {
		[[[filters cells] objectAtIndex:i] setTarget:self];
		[[[filters cells] objectAtIndex:i] setAction:@selector(filterChanged:)];
	}
	
	// Set up the View NSPredicates
	completeFilter = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
						{
							TorrentModel *t = evaluatedObject;
							if ([t size] == [t downloaded]) {
								return YES;
							} else {
								return NO;
							}
						}];
	incompleteFilter = [NSPredicate predicateWithBlock:^(id evaluatedObject, NSDictionary *bindings)
						{
							TorrentModel *t = evaluatedObject;
							if ([t size] == [t downloaded]) {
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
	
	// Load the column order/visibility/size settings
	[torrentTable setAutosaveName:@"org.shadowrealm.mrtorrent.All"];
	
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

- (void)addLocalTorrentFile:(NSString *)filename
{
	NSLog(@"%@", filename);
	NSData *torrentData = [[NSFileManager defaultManager] contentsAtPath:filename];
	
	[torrentListModel addTorrentWithData:torrentData];

	[self updateTorrentListModel];
	
	// TODO: This should be an option
	// Delete the .torrent file, now we've added it to rtorrent
	NSFileManager *manager = [NSFileManager defaultManager];
	[manager removeItemAtPath:filename error:nil];	
}

- (IBAction)addTorrentFile:(id)sender
{
	// Create the File Open Dialog class.
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	
	// Enable the selection of files in the dialog.
	[openDlg setCanChooseFiles:YES];
	
	// Enable the selection of directories in the dialog.
	[openDlg setCanChooseDirectories:NO];
	
	// Disable Multiple Selection
	[openDlg setAllowsMultipleSelection:NO];
	
	// Types we allow
	NSArray* fileType = [NSArray arrayWithObjects: @"torrent", nil];
	
	// Display the dialog. If the OK button was pressed,
	// process the files.
	if ( [openDlg runModalForDirectory:nil file:nil types:fileType] == NSOKButton )
	{
		NSArray *files = [openDlg URLs];
		NSURL *url = [files objectAtIndex:0];
		NSString *fileName = [url path];
		[self addLocalTorrentFile:fileName];
		
		// (Optionally) delete the .torrent file, now we've added it to rtorrent
		if ([[NSUserDefaults standardUserDefaults] boolForKey:SRODeleteOnAdd]) {
			NSFileManager *manager = [NSFileManager defaultManager];
			[manager removeItemAtURL:url error:nil];
		}
	}
}


#pragma mark events
- (void)onTimer:(NSTimer *)timer
{
	[self updateTorrentListModel];
	[self updateRateModel];
}

- (IBAction)filterChanged:(id)sender
{
	NSString *newView = [NSString stringWithString:[[filters selectedCell] title]];
	
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
