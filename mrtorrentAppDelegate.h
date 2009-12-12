//
//  mrtorrentAppDelegate.h
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//

#import <Cocoa/Cocoa.h>

@interface mrtorrentAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;

@property (assign) IBOutlet NSWindow *window;

@end
