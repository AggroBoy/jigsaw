//
//  MainView.m
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//

#import "MainView.h"
#import "Torrent.h"
#import <dispatch/dispatch.h>


@implementation MainView

#pragma mark initialistion
-  (void)awakeFromNib
{
	[rateModel setDelegate:self];
	
	for (NSInteger i = 0; i < [[views cells] count]; i++) {
		[[[views cells] objectAtIndex:i] setTarget:self];
		[[[views cells] objectAtIndex:i] setAction:@selector(viewChanged:)];
	}

	defaultDownThrottles = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
							[NSNumber numberWithInt:20],[NSNumber numberWithInt:50],[NSNumber numberWithInt:100],
							[NSNumber numberWithInt:200],[NSNumber numberWithInt:400],[NSNumber numberWithInt:0], nil];
	
	defaultUpThrottles = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
						  [NSNumber numberWithInt:10],[NSNumber numberWithInt:20],[NSNumber numberWithInt:40],
						  [NSNumber numberWithInt:0], nil];
	
	[self updateTorrentListModel];
	[self updateRateModel];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimer:) userInfo:nil repeats:TRUE];
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


- (IBAction)viewChanged:(id)sender
{
	NSString *newView = [NSString stringWithString:[[views selectedCell] title]];
	
	if ([newView isEqualToString:@"All"]) {
		[torrentListModel setView:@"main"];
	}
	if ([newView isEqualToString:@"Complete"]) {
		[torrentListModel setView:@"complete"];
	}
	if ([newView isEqualToString:@"Incomplete"]) {
		[torrentListModel setView:@"incomplete"];
	}
	
	[torrentListModel update];
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
	Torrent *torrent = [[torrentListController selectedObjects] objectAtIndex:0];

	if (torrent != nil) {
		[torrentListModel stopTorrent:torrent];
	}
}

- (IBAction)startTorrent:(id)sender
{
	Torrent *torrent = [[torrentListController selectedObjects] objectAtIndex:0];
	
	if (torrent != nil) {
		[torrentListModel startTorrent:torrent];
	}
}

- (IBAction)deleteTorrent:(id)sender
{
	Torrent *torrent = [[torrentListController selectedObjects] objectAtIndex:0];
	
	if (torrent != nil) {
		[torrentListModel deleteTorrent:torrent];
	}
}

- (BOOL)validateMenuItem:(NSMenuItem *)item
{
	Torrent *torrent = nil;
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

@end
