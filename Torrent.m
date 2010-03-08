//
//  Torrent.m
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import "Torrent.h"


@implementation Torrent

+ (Torrent *)withName:(NSString *)name
{
	Torrent *torrent = [[Torrent alloc] init];
	[torrent setName:name];
	return torrent;
}

@synthesize name;
@synthesize hash;
@synthesize size;
@synthesize upRate;
@synthesize upTotal;
@synthesize downRate;
@synthesize completedBytes;
@synthesize ratio;
@synthesize active;


- (id)copyWithZone:(NSZone *)zone
{
	Torrent *torrent = [Torrent withName:name];
	[torrent setHash:hash];
	[torrent setUpRate:upRate];
	[torrent setUpTotal:upTotal];
	[torrent setDownRate:downRate];
	[torrent setCompletedBytes:completedBytes];
	[torrent setRatio:ratio];
	[torrent setActive:active];
	
	return torrent;
}

@end
