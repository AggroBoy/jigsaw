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
	
	NSInteger torrentCount = [elements count] / 7;
	for (NSInteger i = 0; i < torrentCount; i++) {
		NSInteger firstElementOfTorrent = i * 7;
		Torrent *torrent = [Torrent withName:[elements objectAtIndex:firstElementOfTorrent]];
		[torrent setSize:[[elements objectAtIndex:firstElementOfTorrent + 1] intValue]];

		[torrent setUpRate:[[elements objectAtIndex:firstElementOfTorrent + 2] intValue]];
		[torrent setUpTotal:[[elements objectAtIndex:firstElementOfTorrent + 3] intValue]];
		[torrent setDownRate:[[elements objectAtIndex:firstElementOfTorrent + 4] intValue]];
		[torrent setCompletedBytes:[[elements objectAtIndex:firstElementOfTorrent + 5] intValue]];
		
		[torrent setRatio:[[elements objectAtIndex:firstElementOfTorrent + 6] doubleValue]];
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
							   @"d.get_size_bytes=",
							   @"d.get_up_rate=",
							   @"d.get_up_total=",
							   @"d.get_down_rate=",
							   @"d.get_completed_bytes=",
							   @"d.get_ratio=",
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
