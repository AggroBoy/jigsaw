//
//  Torrent.m
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import "TorrentModel.h"
#import "XMLRPC/XMLRPC.h"


@implementation TorrentModel

#pragma mark initialisation

+ (TorrentModel *)withHash:(NSString *)hash
{
	TorrentModel *torrent = [[TorrentModel alloc] init];
	[torrent setHash:hash];
	return torrent;
}


#pragma mark properties

@synthesize name;
@synthesize hash;
@synthesize size;
@synthesize upRate;
@synthesize uploaded;
@synthesize downRate;
@synthesize downloaded;
@synthesize ratio;
@synthesize active;
@synthesize url;

- (BOOL) active
{
	return active;
}

- (void) setActive:(BOOL)newActive
{
	if (newActive != active) {
		active = newActive;
		if (url != nil) {
			if (active) {
				[self start];
			} else {
				[self stop];
			}
		}
	}
}


#pragma mark control of remote torrent

- (void) start
{
	NSLog(@"start");
	
	NSURL *URL = [NSURL URLWithString:url];
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
	[request setMethod: @"d.start" withParameter:hash];
	[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
}

- (void) stop
{
	NSLog(@"Stop");
	
	NSURL *URL = [NSURL URLWithString:url];
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
	[request setMethod: @"d.stop" withParameter:hash];
	[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
}

- (void) remove
{
	NSLog(@"delete");
	
	NSURL *URL = [NSURL URLWithString:url];
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
	[request setMethod: @"d.erase" withParameter:hash];
	[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
}


#pragma mark calculated properties

- (double) proportionComplete
{
	return downloaded / size;
}

- (unsigned long long) secondsRemaining
{
	long long bytesRemaining = size - downloaded;
	if ( bytesRemaining == 0 ) {
		return 0;
	}
	
	long long rate = downRate;
	if (rate == 0) {
		return ULLONG_MAX;
	} else {
		long long secondsRemaining = bytesRemaining / rate;
		return secondsRemaining;
	}
}

- (double) normalisedRatio
{
	return ratio / 1000; 
}


#pragma mark system overrrides

- (id)copyWithZone:(NSZone *)zone
{
	TorrentModel *torrent = [TorrentModel withHash:name];
	[torrent setHash:hash];
	[torrent setUpRate:upRate];
	[torrent setUploaded:uploaded];
	[torrent setDownRate:downRate];
	[torrent setDownloaded:downloaded];
	[torrent setRatio:ratio];
	[torrent setActive:active];
	[torrent setUrl:url];
	
	return torrent;
}

- (BOOL)isEqual:(TorrentModel*)other
{
	return [hash isEqual:[other hash]];
}

@end
