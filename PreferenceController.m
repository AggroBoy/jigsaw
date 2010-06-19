//
//  PreferenceController.m
//  jigsaw
//
//  Created by Will Goring on 19/06/2010.
//

#import "PreferenceController.h"

NSString * const SROURL = @"URL";
NSString * const SROUpdate = @"UpdateFrequency";
NSString * const SROHiddenUpdate = @"HiddenUpdateFrequency";
NSString * const SROUpdateWhileHidden = @"UpdateWhileHidden";
NSString * const SRODeleteOnAdd = @"DeleteOnAdd";

@implementation PreferenceController

- (id)init
{
	if (![super initWithWindowNibName:@"Preferences"]) {
		return nil;
	}
	
	return self;
}

- (NSString*)url
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults stringForKey:SROURL];
}

- (int)update
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey:SROUpdate];
}

- (int)hiddenUpdate
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults integerForKey:SROHiddenUpdate];
}

- (BOOL)updateWhileHidden
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:SROUpdateWhileHidden];
}

- (BOOL)deleteOnAdd
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	return [defaults boolForKey:SRODeleteOnAdd];
}

- (void)windowDidLoad
{
	[urlField setStringValue:[self url]];
	
	[updateField setIntValue:[self update]];
	[hiddenUpdateField setIntValue:[self hiddenUpdate]];
	[updateWhileHiddenCheckbox setState:[self updateWhileHidden]];
	
	[deleteOnAddCheckbox setState:[self deleteOnAdd]];
}

- (IBAction)changeUrl:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setObject:[urlField stringValue] forKey:SROURL];
}

- (IBAction)changeUpdate:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:[updateField intValue] forKey:SROUpdate];
}

- (IBAction)changeHiddenUpdate:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:[hiddenUpdateField intValue] forKey:SROHiddenUpdate];
}

- (IBAction)changeUpdateWhileHidden:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[updateWhileHiddenCheckbox state] forKey:SROUpdateWhileHidden];
	if ([updateWhileHiddenCheckbox state]) {
		[hiddenUpdateField setEnabled:YES];
	} else {
		[hiddenUpdateField setEnabled:NO];
	}
}

- (IBAction)changeDeleteOnAdd:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setBool:[deleteOnAddCheckbox state] forKey:SROUpdateWhileHidden];
}

@end
