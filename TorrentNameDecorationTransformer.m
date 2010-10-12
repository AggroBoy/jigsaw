//
//  TorrentNameDecorationTransformer.m
//  jigsaw
//
//  Created by Will Goring on 29/03/2010.
//

#import "TorrentNameDecorationTransformer.h"


@implementation TorrentNameDecorationTransformer

+ (Class)transformedValueClass
{
	return [NSAttributedString class];
}

+ (BOOL)allowsReverseTransformation
{
    return NO;
}

- (id)transformedValue:(id)value
{
	NSString *val = value;
	NSMutableAttributedString *work = [[NSMutableAttributedString new] initWithString:val];
	[work setAttributes:[NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName] range:NSMakeRange(0, 5)];
	return [[NSAttributedString new] initWithAttributedString:work];
}

@end
