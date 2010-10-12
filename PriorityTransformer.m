//
//  PriorityTransformer.m
//  jigsaw
//
//  Created by Will Goring on 12/10/2010.
//  Copyright 2010 Will Goring. All rights reserved.
//

#import "PriorityTransformer.h"


@implementation PriorityTransformer

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
	if ([value respondsToSelector: @selector(intValue)]) {
		
		int priority = [value intValue];
		
		if (priority == 1) {
			return @"low";
		} else if (priority == 2) {
			return @"normal";
		} else if (priority == 3) {
			return @"high";
		}
	}
	return value;
}

@end
