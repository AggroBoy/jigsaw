//
//  PreferenceController.m
//  jigsaw
//
//  Created by Will Goring on 19/06/2010.
//

#import "PreferenceController.h"

NSString * const SRODeleteOnAdd = @"DeleteOnAdd";

@implementation PreferenceController

- (id)init
{
	if (![super initWithWindowNibName:@"Preferences"]) {
		return nil;
	}
	
	return self;
}

- (BOOL)deleteOnAdd
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:SRODeleteOnAdd];
}

- (void)windowDidLoad
{
	[deleteOnAddCheckbox setState:[self deleteOnAdd]];
}

- (IBAction)changeDeleteOnAdd:(id)sender
{
	int state = [deleteOnAddCheckbox state];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:state forKey:SRODeleteOnAdd];
}

@end
