//
//  Torrent.h
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Torrent : NSObject <NSCopying> {
	NSString *name;
	NSInteger upRate;
	double ratio;
}

+ (Torrent *)withName:(NSString *)name;

- (void)setName:(NSString *)name;

- (NSString *)name;

- (void)setUpRate:(NSInteger)upRate;

- (NSInteger)upRate;

- (void)setRatio:(double)ratio;

- (double)ratio;

@end
