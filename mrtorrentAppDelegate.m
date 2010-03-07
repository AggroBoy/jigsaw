//
//  mrtorrentAppDelegate.m
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//
#import "XMLRPC/XMLRPC.h"

#import "mrtorrentAppDelegate.h"

@implementation mrtorrentAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Init code goes here
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

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
	[self addLocalTorrentFile:filename];
	
	// TODO: This should be an option
	// Delete the .torrent file, now we've added it to rtorrent
	NSFileManager *manager = [NSFileManager defaultManager];
	[manager removeItemAtPath:filename error:nil];
	
	return YES;
}

- (void)addLocalTorrentFile:(NSString *)filename
{
	NSLog(@"%@", filename);
	NSData *torrentData = [[NSFileManager defaultManager] contentsAtPath:filename];
	
	NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
	[request setMethod: @"load_raw_start" withParameter:torrentData];
	[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
	
	[torrentList update];
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
		
		// TODO: This should be an option
		// Delete the .torrent file, now we've added it to rtorrent
		NSFileManager *manager = [NSFileManager defaultManager];
		[manager removeItemAtURL:url error:nil];
	}
}

- (IBAction)addTorrentURL:(id)sender
{
	
}

@end
