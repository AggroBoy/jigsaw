//
//  Torrent.h
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TorrentModel : NSObject <NSCopying> {
	NSString *name;
	NSString *hash;

	long long size;
	
	long long upRate;
	long long uploaded;
	long long downRate;
	long long downloaded;
	
	double ratio;
	
	BOOL active;
	
	NSString* url;
}

@property(readwrite, copy) NSString* name;
@property(readwrite, copy) NSString* hash;
@property(readwrite, assign) long long size;
@property(readwrite, assign) long long upRate;
@property(readwrite, assign) long long uploaded;
@property(readwrite, assign) long long downRate;
@property(readwrite, assign) long long downloaded;
@property(readwrite, assign) double ratio;
@property(readwrite, assign) BOOL active;
@property(readwrite, assign) NSString* url;

+ (TorrentModel *)withHash:(NSString *)hash;

- (BOOL)isEqual:(TorrentModel*)other;

- (double) proportionComplete;
- (long long) secondsRemaining;
- (double) normalisedRatio;

- (void) start;
- (void) stop;
- (void) remove;


@end
