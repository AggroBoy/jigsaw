//
//  SecondsToReadableDurationTransformer.h
//  jigsaw
//
//  Created by Will Goring on 11/03/2010.
//

#import <Cocoa/Cocoa.h>


@interface SecondsToReadableDurationTransformer : NSValueTransformer {

}

+ (Class)transformedValueClass;

+ (BOOL)allowsReverseTransformation;

@end
