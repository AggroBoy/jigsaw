//
//  TorrentTable.m
//  jigsaw
//
//  Created by Will Goring on 17/03/2010.
//

#import "TorrentTable.h"


@implementation TorrentTable

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	// select the row that was clicked before showing the menu for the event
	NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	int row = [self rowAtPoint:mousePoint];
	
	[self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];

	return [super menuForEvent:theEvent];
}
@end
