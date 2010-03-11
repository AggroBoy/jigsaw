//
//  bytesToReadbleSizeTransformer.h
//  mrtorrent
//
//  Created by Will Goring on 10/03/2010.
//  Copyright 2010. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BytesToReadableSizeTransformer : NSValueTransformer {
	NSArray *tokens;
}

+ (Class)transformedValueClass;

+ (BOOL)allowsReverseTransformation;

@end
