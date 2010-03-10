//
//  TorrentListModel.h
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Torrent.h"

@interface TorrentListModel : NSObject <NSXMLParserDelegate> {
	IBOutlet NSMatrix *views;
	IBOutlet NSTableView *tableView;
	IBOutlet NSNumberFormatter *numberFormatter;
	
	NSMutableArray *torrentList;
	NSMutableString *textInProgress;
	NSMutableArray *building;
	NSMutableArray *elements;
	
	NSString *view;

}

- (IBAction)viewChanged:(id)sender;

- (BOOL)validateMenuItem:(NSMenuItem *)item;
- (IBAction)startTorrent:(id)sender;
- (IBAction)stopTorrent:(id)sender;
- (IBAction)deleteTorrent:(id)sender;

- (void)update;

@property (readwrite, assign) NSMutableArray* torrentList;

@end
