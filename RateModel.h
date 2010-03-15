//
//  RateModel.h
//  mrtorrent
//
//  Created by Will Goring on 10/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RateModel : NSObject <NSXMLParserDelegate> {
	NSNumber *downBandwidth;
	NSNumber *upBandwidth;
	NSNumber *downLimit;
	NSNumber *upLimit;
	
	
	NSMutableString *textInProgress;
	NSInteger xmlValue;
}

- (void)update;

- (void)setUpThrottle:(NSInteger) bytesPerSecond;
- (void)setDownThrottle:(NSInteger) bytesPerSecond;

@property (readwrite, assign) NSNumber* downBandwidth;
@property (readwrite, assign) NSNumber* upBandwidth;
@property (readwrite, assign) NSNumber* downLimit;
@property (readwrite, assign) NSNumber* upLimit;


@end
