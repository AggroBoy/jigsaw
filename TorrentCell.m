//
//  TorrentCell.m
//  mrtorrent
//
//  Created by Will Goring on 08/12/2009.
//

#import "TorrentCell.h"
#import "Torrent.h"


@implementation TorrentCell

-(id)init
{
	[super init];
	NSFont *normalFont = [NSFont fontWithName:@"Lucida Grande" size:13.0];
	normalAttrsDictionary = [NSDictionary dictionaryWithObject:normalFont forKey:NSFontAttributeName];
	
	NSFont *smallFont = [NSFont fontWithName:@"Lucida Grande" size:9.0];
	smallAttrsDictionary = [NSDictionary dictionaryWithObject:smallFont forKey:NSFontAttributeName];
	
	return self;
}

-(void)drawInteriorWithFrame:(NSRect)theFrame inView:(NSView *)theView
{
	Torrent *torrent = [self objectValue];
	
	// The torrent name
	NSRect nameRect = NSMakeRect(theFrame.origin.x, theFrame.origin.y, theFrame.size.width - 35, theFrame.size.height);

	[[torrent name] drawInRect:nameRect withAttributes:normalAttrsDictionary];
	
	// The ratio
	NSRect ratioRect = NSMakeRect(theFrame.origin.x + theFrame.size.width - 30, theFrame.origin.y, 30, theFrame.size.height);
	NSString *ratio = [NSString stringWithFormat:@"%.2f",[torrent ratio]/1000];
	[ratio drawInRect:ratioRect withAttributes:smallAttrsDictionary];
}

@end
