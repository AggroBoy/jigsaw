//
//  Torrent.m
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import "Torrent.h"


@implementation Torrent

+ (Torrent *)withHash:(NSString *)hash
{
	Torrent *torrent = [[Torrent alloc] init];
	[torrent setHash:hash];
	return torrent;
}

@synthesize name;
@synthesize hash;
@synthesize size;
@synthesize upRate;
@synthesize uploaded;
@synthesize downRate;
@synthesize downloaded;
@synthesize ratio;
@synthesize active;

- (NSNumber*) proportionComplete
{
	return [NSNumber numberWithDouble:[downloaded doubleValue] / [size doubleValue]];
}

- (NSNumber*) secondsRemaining
{
	long long bytesRemaining = [size longLongValue] - [downloaded longLongValue];
	if ( bytesRemaining == 0 ) {
		return [NSNumber numberWithInt:0];
	}
	
	long long rate = [downRate longLongValue];
	if (rate == 0) {
		return [NSNumber numberWithInt:-1];
	} else {
		long long secondsRemaining = bytesRemaining / rate;
		return [NSNumber numberWithInt:secondsRemaining];
	}
}

- (NSNumber*) normalisedRatio
{
	return [NSNumber numberWithDouble:ratio / 1000]; 
}


- (id)copyWithZone:(NSZone *)zone
{
	Torrent *torrent = [Torrent withHash:name];
	[torrent setHash:hash];
	[torrent setUpRate:upRate];
	[torrent setUploaded:uploaded];
	[torrent setDownRate:downRate];
	[torrent setDownloaded:downloaded];
	[torrent setRatio:ratio];
	[torrent setActive:active];
	
	return torrent;
}

- (BOOL)isEqual:(Torrent*)other
{
	return [hash isEqual:[other hash]];
}

@end
