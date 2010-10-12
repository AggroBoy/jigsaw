//
//  TorrentListModel.h
//  jigsaw
//
//  Created by Will Goring on 09/12/2009.
//

#import <Foundation/Foundation.h>
#import "TorrentModel.h"

@interface TorrentListModel : NSObject <NSXMLParserDelegate> {
	NSArray *torrentList;
	
	NSMutableArray *elements;
	NSMutableString *textInProgress;
	
	dispatch_queue_t torrentListUpdateQueue;
}

- (void)update;
- (void)addTorrentWithData:(NSData*)data;

@property (readwrite, assign) NSArray* torrentList;

@end
