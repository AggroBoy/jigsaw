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
	NSString *hash;

	NSInteger size;
	
	NSInteger upRate;
	NSInteger upTotal;
	NSInteger downRate;
	NSInteger completedBytes;
	
	double ratio;
	
	NSInteger active;
}

+ (Torrent *)withName:(NSString *)name;

@property(readwrite, copy) NSString* name;
@property(readwrite, copy) NSString* hash;
@property(readwrite, assign) NSInteger size;
@property(readwrite, assign) NSInteger upRate;
@property(readwrite, assign) NSInteger upTotal;
@property(readwrite, assign) NSInteger downRate;
@property(readwrite, assign) NSInteger completedBytes;
@property(readwrite, assign) double ratio;
@property(readwrite, assign) NSInteger active;

@end
