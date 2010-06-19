//
//  PreferenceController.h
//  jigsaw
//
//  Created by Will Goring on 19/06/2010.
//  Copyright 2010 Yell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const SRODeleteOnAdd;

@interface PreferenceController : NSWindowController {
	IBOutlet NSButton *deleteOnAddCheckbox;
}

- (IBAction)changeDeleteOnAdd:(id)sender;

@end