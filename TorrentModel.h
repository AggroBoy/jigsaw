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

	NSNumber* size;
	
	NSNumber* upRate;
	NSNumber* uploaded;
	NSNumber* downRate;
	NSNumber* downloaded;
	
	double ratio;
	
	BOOL active;
	
	NSString* url;
}

@property(readwrite, copy) NSString* name;
@property(readwrite, copy) NSString* hash;
@property(readwrite, assign) NSNumber* size;
@property(readwrite, assign) NSNumber* upRate;
@property(readwrite, assign) NSNumber* uploaded;
@property(readwrite, assign) NSNumber* downRate;
@property(readwrite, assign) NSNumber* downloaded;
@property(readwrite, assign) double ratio;
@property(readwrite, assign) BOOL active;
@property(readwrite, assign) NSString* url;

+ (TorrentModel *)withHash:(NSString *)hash;

- (BOOL)isEqual:(TorrentModel*)other;

- (NSNumber*) proportionComplete;
- (NSNumber*) secondsRemaining;
- (NSNumber*) normalisedRatio;

- (void) start;
- (void) stop;
- (void) remove;


@end
