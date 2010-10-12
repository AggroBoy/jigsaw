//
//  PriorityTransformer.h
//  jigsaw
//
//  Created by Will Goring on 12/10/2010.
//  Copyright 2010 Will Goring. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PriorityTransformer : NSValueTransformer {

}

+ (Class)transformedValueClass;

+ (BOOL)allowsReverseTransformation;

@end
