//
//  mrtorrentAppDelegate.h
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//

#import <Cocoa/Cocoa.h>

#import "TorrentListModel.h";
#import "MainController.h";

@interface mrtorrentAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    NSWindow *window;
	IBOutlet TorrentListModel *torrentList;
	IBOutlet MainController *mainController;
	
	NSString *fileToOpen;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;

- (void)windowWillClose:(NSNotification*)notification;

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename;

+ (void)initialize;



@property (assign) IBOutlet NSWindow *window;

@end
