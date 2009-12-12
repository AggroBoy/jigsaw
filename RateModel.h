//
//  RateModel.h
//  mrtorrent
//
//  Created by Will Goring on 10/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RateModel : NSObject <NSXMLParserDelegate> {
	IBOutlet NSTextField *upBandwidth;
	IBOutlet NSTextField *downBandwidth;
	IBOutlet NSPopUpButton *upThrottlePopup;
	IBOutlet NSPopUpButton *downThrottlePopup;
	
	NSArray *defaultDownThrottles;
	NSArray *defaultUpThrottles;
	
	NSMutableString *textInProgress;
	NSInteger xmlValue;
}

- (void)update;

- (IBAction)upThrottleChanged:(id)sender;

- (IBAction)downThrottleChanged:(id)sender;


@end
