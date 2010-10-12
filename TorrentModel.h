//
//  Torrent.h
//  jigsaw
//
//  Created by Will Goring on 09/12/2009.
//

#import <Foundation/Foundation.h>


@interface TorrentModel : NSObject <NSCopying> {
	NSString *name;
	NSString *hash;

	unsigned long long size;
	
	unsigned long long upRate;
	unsigned long long uploaded;
	unsigned long long downRate;
	unsigned long long downloaded;
	
	double ratio;
	
	BOOL active;
	
	unsigned long long priority;
	
	NSString* url;
}

@property(readwrite, copy) NSString* name;
@property(readwrite, copy) NSString* hash;
@property(readwrite, assign) unsigned long long size;
@property(readwrite, assign) unsigned long long upRate;
@property(readwrite, assign) unsigned long long uploaded;
@property(readwrite, assign) unsigned long long downRate;
@property(readwrite, assign) unsigned long long downloaded;
@property(readwrite, assign) double ratio;
@property(readwrite, assign) BOOL active;
@property(readwrite, assign) NSString* url;
@property(readwrite, assign) unsigned long long priority;

+ (TorrentModel *)withHash:(NSString *)hash;

- (BOOL)isEqual:(TorrentModel*)other;

- (double) proportionComplete;
- (unsigned long long) secondsRemaining;
- (double) normalisedRatio;

- (void) start;
- (void) stop;
- (void) remove;
- (void) changePriority:(int)new_priority;


@end
