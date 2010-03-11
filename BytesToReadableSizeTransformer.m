//
//  bytesToReadbleSizeTransformer.m
//  mrtorrent
//
//  Created by Will Goring on 10/03/2010.
//  Copyright 2010. All rights reserved.
//

#import "BytesToReadableSizeTransformer.h"


@implementation BytesToReadableSizeTransformer

- (id)init
{
	[super init];
	tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",nil];
	return self;
}

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
	if ([value respondsToSelector: @selector(doubleValue)]) {

		double convertedValue = [value doubleValue];
		int multiplyFactor = 0;
				
		while (convertedValue > 1024) {
			convertedValue /= 1024;
			multiplyFactor++;
		}
		
		return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor], value];
	}
	return @"";
}

@end
