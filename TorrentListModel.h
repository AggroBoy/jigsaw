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
	NSArray *torrentList;
	NSString *view;
	
	NSMutableArray *elements;
	NSMutableString *textInProgress;
}

- (NSMutableArray*)parseXml:(NSString*) xml;


- (void)startTorrent:(Torrent*)torrent;
- (void)stopTorrent:(Torrent*)torrent;
- (void)deleteTorrent:(Torrent*)torrent;

- (void)update;

@property (readwrite, assign) NSArray* torrentList;
@property (readwrite, copy) NSString* view;

@end
