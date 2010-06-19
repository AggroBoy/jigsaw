//
//  untitled.m
//  mrtorrent
//
//  Created by Will Goring on 11/03/2010.
//

#import "BytesToReadableSpeedTransformer.h"


@implementation BytesToReadableSpeedTransformer

- (id)transformedValue:(id)value
{
	if ([value respondsToSelector: @selector(intValue)]) {
		
		double convertedValue = [value intValue];
		if (convertedValue == 0) {
			return [[NSAttributedString new] initWithString:@"-" attributes:[NSDictionary dictionaryWithObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName]];
		}
	}
	
	NSMutableString * output = [NSMutableString stringWithString:[super transformedValue:value]];
	[output appendString:@"/s"];
	return output;
}
@end
