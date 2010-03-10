//
//  bytesToReadbleSizeTransformer.h
//  mrtorrent
//
//  Created by Will Goring on 10/03/2010.
//  Copyright 2010 Yell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BytesToReadbleSizeTransformer : NSValueTransformer {
	NSArray *tokens;
}

+ (Class)transformedValueClass;

+ (BOOL)allowsReverseTransformation;

@end
