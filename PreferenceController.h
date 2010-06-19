//
//  PreferenceController.h
//  jigsaw
//
//  Created by Will Goring on 19/06/2010.
//

#import <Cocoa/Cocoa.h>

extern NSString * const SROURL;
extern NSString * const SROUpdate;
extern NSString * const SROHiddenUpdate;
extern NSString * const SROUpdateWhileHidden;
extern NSString * const SRODeleteOnAdd;

@interface PreferenceController : NSWindowController {
	IBOutlet NSTextField *urlField;
	
	IBOutlet NSTextField *updateField;
	IBOutlet NSTextField *hiddenUpdateField;
	
	IBOutlet NSButton *updateWhileHiddenCheckbox;
	
	IBOutlet NSButton *deleteOnAddCheckbox;
}

- (IBAction)changeUrl:(id)sender;

- (IBAction)changeUpdate:(id)sender;
- (IBAction)changeHiddenUpdate:(id)sender;
- (IBAction)changeUpdateWhileHidden:(id)sender;

- (IBAction)changeDeleteOnAdd:(id)sender;

@end
