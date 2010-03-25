//
//  TorrentListModel.m
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//

#import "TorrentListModel.h"
#import "XMLRPC/XMLRPC.h"

@implementation TorrentListModel

#pragma mark initialisation
- (id)init
{
	[super init];
	
	url = @"http://horus/RPC2";
	
	torrentListUpdateQueue = dispatch_queue_create("org.shadowrealm.mrtorrent.torrentListUpdate", NULL);
	dispatch_retain(torrentListUpdateQueue);
	
	return self;
}


#pragma mark data handling
- (NSMutableArray*)parseXml:(NSString*) xml
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSASCIIStringEncoding]];
	[parser setDelegate:self];
	
	elements = [NSMutableArray array];
	
	[parser parse];
	
	NSInteger torrentCount = [elements count] / 9;
	NSMutableArray* newTorrentList = [NSMutableArray arrayWithCapacity:torrentCount];
	
	for (NSInteger i = 0; i < torrentCount; i++) {
		NSInteger firstElementOfTorrent = i * 9;
		int offset = 0;
		TorrentModel *torrent = [TorrentModel withHash:[elements objectAtIndex:firstElementOfTorrent + offset++]];
		
		[torrent setName:[elements objectAtIndex:firstElementOfTorrent + offset++]];
		[torrent setSize:[elements objectAtIndex:firstElementOfTorrent + offset++]];
		
		[torrent setUpRate:[elements objectAtIndex:firstElementOfTorrent + offset++]];
		[torrent setUploaded:[elements objectAtIndex:firstElementOfTorrent + offset++]];
		
		[torrent setDownRate:[elements objectAtIndex:firstElementOfTorrent + offset++]];
		[torrent setDownloaded:[elements objectAtIndex:firstElementOfTorrent + offset++]];
		
		[torrent setRatio:[[elements objectAtIndex:firstElementOfTorrent + offset++] doubleValue]];
		[torrent setActive:[[elements objectAtIndex:firstElementOfTorrent + offset++] longLongValue] == 1];
		
		[torrent setUrl:url];
		
		[newTorrentList addObject:torrent];
	}
	
	return newTorrentList;
}

- (void)update
{
	dispatch_async(torrentListUpdateQueue, ^{

		NSURL *URL = [NSURL URLWithString:url];
		XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
		// multicall takes the view, followed by the list of fields (one per object)
		NSArray *parameters = [NSArray arrayWithObjects:@"main",
							   @"d.get_hash=",
							   @"d.get_name=",
							   @"d.get_size_bytes=",
							   @"d.get_up_rate=",
							   @"d.get_up_total=",
							   @"d.get_down_rate=",
							   @"d.get_bytes_done=",
							   @"d.get_ratio=",
							   @"d.is_active=",
							   nil
						   ];
		
		[request setMethod: @"d.multicall" withParameters:parameters];
		XMLRPCResponse *response = [XMLRPCConnection sendSynchronousXMLRPCRequest:request];

		dispatch_async(dispatch_get_main_queue(), ^{
			[self setTorrentList:[NSArray arrayWithArray:[self parseXml:response.body]]];
		});
	});
}	


#pragma mark NSXMLParser Delegate calls
-  (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"string"] || [elementName isEqualToString:@"i8"]) {
		textInProgress = [[NSMutableString alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
	if ([elementName isEqualToString:@"string"]) {
		NSString *string = [NSString stringWithString:textInProgress];
		[elements addObject:string];
		
	}
	if ([elementName isEqualToString:@"i8"]) {
		NSNumber *value = [NSNumber numberWithLongLong:[textInProgress longLongValue]];
		[elements addObject:value];
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
@synthesize torrentList;

@end
