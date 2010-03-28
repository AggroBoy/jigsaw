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
#import "TorrentDelegates.h"

@interface MainView : NSObject <RateModelDelegate, NSWindowDelegate> {
	IBOutlet NSMatrix *views;

	IBOutlet NSPopUpButton *upThrottlePopup;
	IBOutlet NSPopUpButton *downThrottlePopup;


	IBOutlet RateModel *rateModel;
	IBOutlet TorrentListModel *torrentListModel;

	IBOutlet NSArrayController *torrentListController;
	
	NSPredicate *completeFilter;
	NSPredicate *incompleteFilter;
	
	IBOutlet NSTableView *torrentTable;
	IBOutlet NSMenu *headerSelectionMenu;
	
	NSTimer *timer;
	
	NSArray *defaultDownThrottles;
	NSArray *defaultUpThrottles;
}

- (void)displayed;
- (void)hidden;

- (void)updateRateModel;
- (void)updateTorrentListModel;

- (void)windowWillClose:(NSNotification*)notification;
- (IBAction)viewChanged:(id)sender;

- (void)didUpdateRates;
- (IBAction)upThrottleChanged:(id)sender;
- (IBAction)downThrottleChanged:(id)sender;

- (IBAction)stopTorrent:(id)sender;
- (IBAction)startTorrent:(id)sender;
- (IBAction)deleteTorrent:(id)sender;
- (BOOL)validateMenuItem:(NSMenuItem *)item;

- (IBAction)changeColumnState:(id)sender;

@end
