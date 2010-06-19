//
//  jigsawAppController.m
//  jigsaw
//
//  Created by Will Goring on 19/06/2010.
//

#import "jigsawAppController.h"
#import "PreferenceController.h"

@implementation jigsawAppController

+ (void) initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	
	[defaultValues setObject:@"http://horus/RPC2" forKey:SROURL];
	
	[defaultValues setObject:[NSNumber numberWithInt:2] forKey:SROUpdate];
	[defaultValues setObject:[NSNumber numberWithInt:120] forKey:SROHiddenUpdate];
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:SROUpdateWhileHidden];
	
	[defaultValues setObject:[NSNumber numberWithBool:NO] forKey:SRODeleteOnAdd];
	 
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}


- (IBAction)showPreferencesPanel:(id)sender
{
	if (!preferenceController) {
		preferenceController = [[PreferenceController alloc] init];
	}
	
	[preferenceController showWindow:self];
}

@end
