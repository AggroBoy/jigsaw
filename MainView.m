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

- (NSString *)stringForPath:(NSString *)xPath ofNode:(NSXMLNode *)node
{
	NSError *error;
	NSArray *nodes = [node nodesForXPath:xPath error:&error];
	return [[nodes objectAtIndex:0] stringValue];
}

- (void)updateTorrentList
{
	[torrentListModel update];
}

- (void)updateRates
{
	[rateModel update];
}

- (void)onTimer:(NSTimer *)timer
{
	if (!waiting) {
		waiting = true;
		[self updateTorrentList];
		[self updateRates];
		waiting = false;	
	}
}

#pragma mark Start-up
-  (void)awakeFromNib
{
	
	[self updateTorrentList];
	[self updateRates];
	
	waiting = false;
	
	timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(onTimer:) userInfo:nil repeats:TRUE];
}
@end
