//
//  MainView.h
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//

#import <Cocoa/Cocoa.h>
#import <XMLRPC/XMLRPC.h>
#import "TorrentListModel.h"
#import "RateModel.h"

@interface MainView : NSObject {
	IBOutlet NSMatrix *views;

	IBOutlet NSPopUpButton *upThrottlePopup;
	IBOutlet NSPopUpButton *downThrottlePopup;


	IBOutlet RateModel *rateModel;
	IBOutlet TorrentListModel *torrentListModel;

	IBOutlet NSArrayController *torrentListController;
	
	NSTimer *timer;
	
	NSArray *defaultDownThrottles;
	NSArray *defaultUpThrottles;
}

- (void)updateRateModel;
- (void)updateTorrentListModel;

- (IBAction)viewChanged:(id)sender;

- (IBAction)upThrottleChanged:(id)sender;
- (IBAction)downThrottleChanged:(id)sender;

- (IBAction)stopTorrent:(id)sender;
- (IBAction)startTorrent:(id)sender;
- (IBAction)deleteTorrent:(id)sender;
- (BOOL)validateMenuItem:(NSMenuItem *)item;

@end
