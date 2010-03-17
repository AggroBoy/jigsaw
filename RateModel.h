//
//  RateModel.h
//  mrtorrent
//
//  Created by Will Goring on 10/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TorrentDelegates.h"


@interface RateModel : NSObject <NSXMLParserDelegate> {
	NSNumber *downBandwidth;
	NSNumber *upBandwidth;
	NSNumber *downLimit;
	NSNumber *upLimit;
	
	
	NSMutableString *textInProgress;
	NSInteger xmlValue;
	
	dispatch_queue_t rateUpdateQueue;
	
	id<RateModelDelegate> delegate;
}

- (void)update;

- (void)setUpThrottle:(NSInteger) bytesPerSecond;
- (void)setDownThrottle:(NSInteger) bytesPerSecond;

@property (readwrite, assign) NSNumber* downBandwidth;
@property (readwrite, assign) NSNumber* upBandwidth;
@property (readwrite, assign) NSNumber* downLimit;
@property (readwrite, assign) NSNumber* upLimit;
@property (readwrite, assign) id<RateModelDelegate> delegate;


@end
