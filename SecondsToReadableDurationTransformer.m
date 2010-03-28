//
//  SecondsToReadableDurationTransformer.m
//  mrtorrent
//
//  Created by Will Goring on 11/03/2010.
//  Copyright 2010 Yell. All rights reserved.
//

#import "SecondsToReadableDurationTransformer.h"


@implementation SecondsToReadableDurationTransformer
+ (Class)transformedValueClass
{
	return [NSString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
	NSNumber* secondsValue = value;
	long long seconds = [secondsValue longLongValue];
	
	if (seconds == 0) {
		return [[NSAttributedString new] initWithString:@"-" attributes:[NSDictionary dictionaryWithObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName]];
	} else if (seconds == ULLONG_MAX) {
		return [[NSAttributedString new] initWithString:@"∞" attributes:[NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName]];
	} else {
		int hours = seconds / 3600;
		seconds %= 3600;
		int minutes = seconds / 60;
		seconds %= 60;
		return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
	}
}

@end
