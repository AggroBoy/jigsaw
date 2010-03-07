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
	greyAttrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:normalFont,NSFontAttributeName,[NSColor lightGrayColor],NSForegroundColorAttributeName,nil];
	
	NSFont *smallFont = [NSFont fontWithName:@"Lucida Grande" size:9.0];
	smallAttrsDictionary = [NSDictionary dictionaryWithObject:smallFont forKey:NSFontAttributeName];
	smallGreyAttrsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:smallFont,NSFontAttributeName,[NSColor lightGrayColor],NSForegroundColorAttributeName,nil];
	
	return self;
}

-(void)drawInteriorWithFrame:(NSRect)theFrame inView:(NSView *)theView
{
	Torrent *torrent = [self objectValue];
	
	NSInteger horizontalOne = theFrame.origin.y;
	NSInteger horizontalTwo = horizontalOne + 18;
	NSInteger horizontalThree = horizontalOne + 28;
	
	NSInteger verticalOne = theFrame.origin.x;
	NSInteger verticalTwo = verticalOne + 35;
	
	// The torrent name
	NSRect nameRect = NSMakeRect(theFrame.origin.x, horizontalOne, theFrame.size.width - 35, 18);
	[[torrent name] drawWithRect:nameRect options:NSStringDrawingUsesLineFragmentOrigin|NSLineBreakByCharWrapping|NSStringDrawingTruncatesLastVisibleLine attributes:([torrent active] == 1 ? normalAttrsDictionary : greyAttrsDictionary)];
	
	// The ratio
	//NSRect ratioRect = NSMakeRect(theFrame.origin.x + theFrame.size.width - 30, theFrame.origin.y, 30, theFrame.size.height);
	//NSString *ratio = [NSString stringWithFormat:@"%.2f",[torrent ratio]/1000];
	//[ratio drawInRect:ratioRect withAttributes:smallAttrsDictionary];

	// The up rate
	NSString *upRate = [NSString stringWithFormat:@"%0.1f",[torrent upRate]/1024.0];
	[upRate drawInRect:NSMakeRect(verticalTwo, horizontalTwo, 50, 20) withAttributes:([torrent upRate] > 0 ? smallAttrsDictionary : smallGreyAttrsDictionary)];
	
	// The down rate
	NSString *downRate = [NSString stringWithFormat:@"%0.1f",[torrent downRate]/1024.0];
	[downRate drawInRect:NSMakeRect(verticalTwo, horizontalThree, 50, 20) withAttributes:([torrent downRate] > 0 ? smallAttrsDictionary : smallGreyAttrsDictionary)];
	
	
}

@end
