//
//  mrtorrentAppDelegate.h
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//

#import <Cocoa/Cocoa.h>

#import "TorrentListModel.h";
#import "MainView.h";

@interface mrtorrentAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	IBOutlet TorrentListModel *torrentList;
	IBOutlet MainView *mainView;
	
	NSString *fileToOpen;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag;

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename;

- (void)addLocalTorrentFile:(NSString *)fileName;

- (IBAction)addTorrentFile:(id)sender;

- (IBAction)addTorrentURL:(id)sender;

+ (void)initialize;



@property (assign) IBOutlet NSWindow *window;

@end
