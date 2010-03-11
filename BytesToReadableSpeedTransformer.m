//
//  untitled.m
//  mrtorrent
//
//  Created by Will Goring on 11/03/2010.
//  Copyright 2010. All rights reserved.
//

#import "BytesToReadableSpeedTransformer.h"


@implementation BytesToReadableSpeedTransformer

- (id)transformedValue:(id)value
{
	NSMutableString * output = [NSMutableString stringWithString:[super transformedValue:value]];
	[output appendString:@"/s"];
	return output;
}
@end
