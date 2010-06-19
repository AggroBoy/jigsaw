//
//  jigsawAppController.h
//  jigsaw
//
//  Created by Will Goring on 19/06/2010.
//

#import <Cocoa/Cocoa.h>
@class PreferenceController;

@interface jigsawAppController : NSObject {
	PreferenceController *preferenceController;
}
- (IBAction)showPreferencesPanel:(id)sender;

@end
