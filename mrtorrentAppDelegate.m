//
//  mrtorrentAppDelegate.m
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//
#import "mrtorrentAppDelegate.h"
#import "BytesToReadableSizeTransformer.h"
#import "BytesToReadableSpeedTransformer.h"
#import "SecondsToReadableDurationTransformer.h"

@implementation mrtorrentAppDelegate

@synthesize window;

+ (void)initialize
{
	BytesToReadableSizeTransformer* sizeTransformer;
	sizeTransformer = [[BytesToReadableSizeTransformer alloc] init];
	[NSValueTransformer setValueTransformer:sizeTransformer forName:@"BytesToReadableSizeTransformer"];
	
	BytesToReadableSpeedTransformer* speedTransformer;
	speedTransformer = [[BytesToReadableSpeedTransformer alloc] init];
	[NSValueTransformer setValueTransformer:speedTransformer forName:@"BytesToReadableSpeedTransformer"];
	
	SecondsToReadableDurationTransformer* durationTransformer;
	durationTransformer = [[SecondsToReadableDurationTransformer alloc] init];
	[NSValueTransformer setValueTransformer:durationTransformer forName:@"SecondsToReadableDurationTransformer"];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[window setDelegate:self];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
	[window makeKeyAndOrderFront:self];
	[mainController displayed];

	return NO;
}

- (void)windowWillClose:(NSNotification*)notification
{
	[mainController hidden];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
	[mainController addLocalTorrentFile:filename];
	
	return YES;
}


@end
