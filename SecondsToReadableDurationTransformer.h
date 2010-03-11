//
//  SecondsToReadableDurationTransformer.h
//  mrtorrent
//
//  Created by Will Goring on 11/03/2010.
//  Copyright 2010 Yell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SecondsToReadableDurationTransformer : NSValueTransformer {

}

+ (Class)transformedValueClass;

+ (BOOL)allowsReverseTransformation;

@end
