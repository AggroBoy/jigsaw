//
//  TorrentListModel.h
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorrentModel.h"

@interface TorrentListModel : NSObject <NSXMLParserDelegate> {
	NSString* url;
	
	NSArray *torrentList;
	
	NSMutableArray *elements;
	NSMutableString *textInProgress;
	
	dispatch_queue_t torrentListUpdateQueue;
}

- (void)update;

@property (readwrite, assign) NSArray* torrentList;

@end
