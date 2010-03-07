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

- (void)setName:(NSString *)torrentName
{
	name = [NSString stringWithString:torrentName];
}

- (NSString *)name
{
	return name;
}

- (void)setHash:(NSString *)torrentHash
{
	hash = [NSString stringWithString:torrentHash];
}

- (NSString *)hash
{
	return hash;
}

- (void)setSize:(NSInteger)torrentSize
{
	size = torrentSize;
}

- (NSInteger)size
{
	return size;
}

- (void)setUpRate:(NSInteger)torrentUpRate
{
	upRate = torrentUpRate;
}

- (NSInteger)upRate
{
	return upRate;
}

- (void)setUpTotal:(NSInteger)torrentUpTotal
{
	upTotal = torrentUpTotal;
}

- (NSInteger)upTotal
{
	return upTotal;
}

- (void)setDownRate:(NSInteger)torrentDownRate
{
	downRate = torrentDownRate;
}

- (NSInteger)downRate
{
	return downRate;
}

- (void)setCompletedBytes:(NSInteger)torrentCompletedBytes
{
	completedBytes = torrentCompletedBytes;
}

- (NSInteger)completedBytes
{
	return completedBytes;
}

- (void)setRatio:(double)torrentRatio
{
	ratio = torrentRatio;
}

- (double)ratio
{
	return ratio;
}

- (void)setActive:(NSInteger)torrentActive
{
	active = torrentActive;
}

- (int)active
{
	return active;
}


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
