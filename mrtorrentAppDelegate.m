//
//  mrtorrentAppDelegate.m
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//

#import "mrtorrentAppDelegate.h"

@implementation mrtorrentAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
	if ([window isVisible]) {
		[window close];
	} else {
		[window makeKeyAndOrderFront:self];
	}
	return NO;
}

@end
