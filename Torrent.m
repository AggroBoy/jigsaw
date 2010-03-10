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
