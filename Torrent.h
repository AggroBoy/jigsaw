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

	NSInteger size;
	
	NSInteger upRate;
	NSInteger upTotal;
	NSInteger downRate;
	NSInteger completedBytes;
	
	double ratio;
}

+ (Torrent *)withName:(NSString *)name;

- (void)setName:(NSString *)name;

- (NSString *)name;

- (void)setSize:(NSInteger)size;

- (NSInteger)size;

- (void)setUpRate:(NSInteger)upRate;

- (NSInteger)upRate;

- (void)setUpTotal:(NSInteger)upTotal;

- (NSInteger)upTotal;

- (void)setDownRate:(NSInteger)downRate;

- (NSInteger)downRate;

- (void)setCompletedBytes:(NSInteger)completedBytes;

- (NSInteger)completedBytes;

- (void)setRatio:(double)ratio;

- (double)ratio;

@end
