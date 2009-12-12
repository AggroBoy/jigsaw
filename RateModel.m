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
	defaultDownThrottles = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
							[NSNumber numberWithInt:20],[NSNumber numberWithInt:50],[NSNumber numberWithInt:100],
							[NSNumber numberWithInt:200],[NSNumber numberWithInt:400],[NSNumber numberWithInt:0], nil];
	
	defaultUpThrottles = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],
						  [NSNumber numberWithInt:10],[NSNumber numberWithInt:20],[NSNumber numberWithInt:40],
						  [NSNumber numberWithInt:0], nil];
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

- (void) updateThrottlePopup: (NSPopUpButton *) popup throttle: (NSInteger) throttle defaultValues: (NSArray *) defaultValues  {
	if ([popup indexOfItemWithTag:throttle] != -1) {
		[popup selectItemWithTag:throttle];
	} else {
		for (NSInteger i = 0; i < [popup numberOfItems]; i++) {
			NSNumber *tag = [NSNumber numberWithInt:[[popup itemAtIndex:i] tag]];
			if (![defaultValues containsObject:tag]) {
				[popup removeItemAtIndex:i];
				break;
			}
		}
		for (NSInteger i = 0; i < [popup numberOfItems]; i++) {
			NSInteger tag = [[popup itemAtIndex:i] tag];
			if (tag > throttle || tag == 0) {
				NSString *title = [NSString stringWithFormat:@"%d KB/s", throttle];
				[popup insertItemWithTitle:title atIndex:i];
				[[popup itemAtIndex:i] setTag:throttle];
				[popup selectItemWithTag:throttle];
				break;
			} 
		}
	}
}

- (void)updateGlobalBandwith
{
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSInteger currentDownBandwidth = [self getIntegerXmlValue:@"get_down_rate"];
		NSInteger currentUpBandwidth = [self getIntegerXmlValue:@"get_up_rate"];
		NSInteger currentDownLimit = [self getIntegerXmlValue:@"get_download_rate"];
		NSInteger currentUpLimit = [self getIntegerXmlValue:@"get_upload_rate"];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[downBandwidth setDoubleValue:currentDownBandwidth/1024.0];
			[upBandwidth setDoubleValue:currentUpBandwidth/1024.0];

			NSInteger upThrottle = currentUpLimit/1024;
			[self updateThrottlePopup:upThrottlePopup throttle:upThrottle defaultValues:defaultUpThrottles];
			
			NSInteger downThrottle = currentDownLimit/1024;
			[self updateThrottlePopup:downThrottlePopup throttle:downThrottle defaultValues:defaultDownThrottles];
		});
	});
}

- (void)update
{
	[self updateGlobalBandwith];
}


#pragma mark Throttle changed actions
- (IBAction)upThrottleChanged:(id)sender
{
	NSLog(@"Up throttle changed to: %d", [[upThrottlePopup selectedItem] tag]);
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
		XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
		
		[request setMethod: @"set_upload_rate" withParameter:[NSString stringWithFormat:@"%d", [[upThrottlePopup selectedItem] tag]*1024]];
		[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
	});
}

- (IBAction)downThrottleChanged:(id)sender
{
	NSLog(@"Up throttle changed to: %d", [[downThrottlePopup selectedItem] tag]);
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
		XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
		
		[request setMethod: @"set_download_rate" withParameter:[NSString stringWithFormat:@"%d", [[downThrottlePopup selectedItem] tag]*1024]];
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

@end
