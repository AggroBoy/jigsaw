//
//  bytesToReadbleSizeTransformer.h
//  mrtorrent
//
//  Created by Will Goring on 10/03/2010.
//

#import <Cocoa/Cocoa.h>


@interface BytesToReadableSizeTransformer : NSValueTransformer {
	NSArray *tokens;
}

+ (Class)transformedValueClass;

+ (BOOL)allowsReverseTransformation;

@end
