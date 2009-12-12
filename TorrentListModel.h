//
//  TorrentListModel.h
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Torrent.h"

@interface TorrentListModel : NSObject <NSXMLParserDelegate> {
	IBOutlet NSMatrix *views;
	IBOutlet NSTableView *tableView;
	
	NSArray *torrentList;
	NSMutableString *textInProgress;
	NSMutableArray *building;
	NSMutableArray *elements;
	
	NSString *view;

}

- (IBAction)viewChanged:(id)sender;

- (void)update;

@end
