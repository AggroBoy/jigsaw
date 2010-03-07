//
//  TorrentListModel.m
//  mrtorrent
//
//  Created by Will Goring on 09/12/2009.
//

#import "TorrentListModel.h"
#import "XMLRPC/XMLRPC.h"
#import "TorrentCell.h"


@implementation TorrentListModel

-  (void)awakeFromNib
{
	torrentList = [NSArray array];

	TorrentCell *torrentCell = [[TorrentCell alloc] init];
	[[[tableView tableColumns] objectAtIndex:0] setDataCell:torrentCell];

	view = @"main";

	for (NSInteger i = 0; i < [[views cells] count]; i++) {
		[[[views cells] objectAtIndex:i] setTarget:self];
		[[[views cells] objectAtIndex:i] setAction:@selector(viewChanged:)];
	}
	
	[tableView setRowHeight:40];
}

- (void)updateWithXml:(NSString *) xml
{
	Torrent *torrent = [Torrent withName:@"woo!"];
	[torrent setUpRate:10];
	[torrent setRatio:1200];
	
	torrentList = [NSArray arrayWithObject:torrent];

	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSASCIIStringEncoding]];
	[parser setDelegate:self];

	elements = [NSMutableArray array];
	building = [NSMutableArray array];

	[parser parse];
	
	NSInteger torrentCount = [elements count] / 9;
	for (NSInteger i = 0; i < torrentCount; i++) {
		NSInteger firstElementOfTorrent = i * 9;
		int offset = 0;
		Torrent *torrent = [Torrent withName:[elements objectAtIndex:firstElementOfTorrent + offset++]];
		[torrent setHash:[elements objectAtIndex:firstElementOfTorrent + offset++]];
		[torrent setSize:[[elements objectAtIndex:firstElementOfTorrent + offset++] intValue]];

		[torrent setUpRate:[[elements objectAtIndex:firstElementOfTorrent + offset++] intValue]];
		[torrent setUpTotal:[[elements objectAtIndex:firstElementOfTorrent + offset++] intValue]];
		[torrent setDownRate:[[elements objectAtIndex:firstElementOfTorrent + offset++] intValue]];

		[torrent setCompletedBytes:[[elements objectAtIndex:firstElementOfTorrent + offset++] intValue]];
		[torrent setRatio:[[elements objectAtIndex:firstElementOfTorrent + offset++] doubleValue]];
		[torrent setActive:[[elements objectAtIndex:firstElementOfTorrent + offset++] intValue]];
		
		[building addObject:torrent];
	}
	
	torrentList = building;
}

- (void)update
{
	dispatch_async(dispatch_get_global_queue(0, 0), ^{

		NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
		XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
		// multicall takes the view, followed by the list of fields (one per object)
		NSArray *parameters = [NSArray arrayWithObjects:view,
							   @"d.get_name=",
							   @"d.get_hash=",
							   @"d.get_size_bytes=",
							   @"d.get_up_rate=",
							   @"d.get_up_total=",
							   @"d.get_down_rate=",
							   @"d.get_completed_bytes=",
							   @"d.get_ratio=",
							   @"d.is_active=",
							   nil
						   ];
		
		[request setMethod: @"d.multicall" withParameters:parameters];
		XMLRPCResponse *response = [XMLRPCConnection sendSynchronousXMLRPCRequest:request];
	
		[self updateWithXml:response.body];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			[tableView reloadData];
		});
	});
}	

- (IBAction)viewChanged:(id)sender
{
	NSString *newView = [NSString stringWithString:[[views selectedCell] title]];
	
	if ([newView isEqualToString:@"All"]) {
		view = @"main";
	}
	if ([newView isEqualToString:@"Complete"]) {
		view = @"complete";
	}
	if ([newView isEqualToString:@"Incomplete"]) {
		view = @"incomplete";
	}
	
	[self update];
}


#pragma mark TableView data source methods
- (int)numberOfRowsInTableView:(NSTableView *)tv
{
	return [torrentList count];
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row
{
	return [torrentList objectAtIndex:row];
}


#pragma mark Menu item methods
- (Torrent *) selectedTorrent {
	// Bizarrely, the usually horrible assign-and-test is actually most readable for this snippet...
	int row;
	if ((row = [tableView clickedRow]) == -1) {
		if ((row = [tableView selectedRow]) == -1) {
			return NO;
		}
	}
	
	return [torrentList objectAtIndex:row];
}

- (BOOL)validateMenuItem:(NSMenuItem *)item
{
	Torrent *torrent = [self selectedTorrent];

	BOOL active = [torrent active];
	
	if ([item action] == @selector(stopTorrent:)) {
		return active ? YES : NO;
	}
	if ([item action] == @selector(startTorrent:)) {
		return active ? NO : YES;
	}
	if ([item action] == @selector(deleteTorrent:)) {
		return active ? NO : YES;
	}
	
	return NO;
}

- (IBAction)stopTorrent:(id)sender
{
	NSLog(@"Stop");

	Torrent *torrent = [self selectedTorrent];

	NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
	[request setMethod: @"d.stop" withParameter:[torrent hash]];
	[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
}

- (IBAction)startTorrent:(id)sender
{
	NSLog(@"start");
	
	Torrent *torrent = [self selectedTorrent];
	
	NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
	[request setMethod: @"d.start" withParameter:[torrent hash]];
	[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
}

- (IBAction)deleteTorrent:(id)sender
{
	NSLog(@"delete");
	
	Torrent *torrent = [self selectedTorrent];
	
	NSURL *URL = [NSURL URLWithString:@"http://horus/RPC2"];
	XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL: URL];
	
	[request setMethod: @"d.erase" withParameter:[torrent hash]];
	[XMLRPCConnection sendSynchronousXMLRPCRequest:request];
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
		NSNumber *value = [NSNumber numberWithInt:[textInProgress intValue]];
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

@end
