//
//  RateModel.m
//  mrtorrent
//
//  Created by Will Goring on 10/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import "RateModel.h"
#import "XMLRPC/XMLRPC.h"


@implementation RateModel

- (void)awakeFromNib
{
}

- (NSInteger)getIntegerXmlValue:(NSString *)method
{
	NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
	[request setMethod: method];
	XMLRPCResponse *response = [XMLRPCConnection sendSynchronousXMLRPCRequest:request];
	NSString *xml = [response body];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSASCIIStringEncoding]];
	[parser setDelegate:self];
	
	[parser parse];
	
	return xmlValue;
}


- (void)update
{
	[self setDownBandwidth:[NSNumber numberWithDouble:[self getIntegerXmlValue:@"get_down_rate"] / 1024.0]];
	[self setUpBandwidth:[NSNumber numberWithDouble:[self getIntegerXmlValue:@"get_up_rate"] / 1024.0]];
	[self setDownLimit:[NSNumber numberWithDouble:[self getIntegerXmlValue:@"get_download_rate"] / 1024.0]];
	[self setUpLimit:[NSNumber numberWithDouble:[self getIntegerXmlValue:@"get_upload_rate"] / 1024.0]];
}


#pragma mark Throttle changed actions
- (void)setUpThrottle:(NSInteger) kPerSecond
{
	NSLog(@"Up throttle changed to: %d", kPerSecond);
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
		XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
		
		[request setMethod: @"set_upload_rate" withParameter:[NSString stringWithFormat:@"%d", kPerSecond * 1024]];
		[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
	});
}

- (void)setDownThrottle:(NSInteger) kPerSecond
{
	NSLog(@"Down throttle changed to: %d", kPerSecond);
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
		XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
		
		[request setMethod: @"set_download_rate" withParameter:[NSString stringWithFormat:@"%d", kPerSecond * 1024]];
		[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
	});
}


#pragma mark NSXMLParser Delegate calls
-  (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"i8"]) {
		textInProgress = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"i8"]) {
		xmlValue = [textInProgress intValue];
	}
}

// This method can get called multiple times for the
// text in a single element
-  (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string
{
	[textInProgress appendString:string];
}


#pragma mark properties

@synthesize downBandwidth;
@synthesize upBandwidth;
@synthesize downLimit;
@synthesize upLimit;


@end
