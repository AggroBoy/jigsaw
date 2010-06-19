//
//  TorrentNameDecorationTransformer.h
//  mrtorrent
//
//  Created by Will Goring on 29/03/2010.
//

#import <Cocoa/Cocoa.h>


@interface TorrentNameDecorationTransformer : NSValueTransformer {

}

+ (Class)transformedValueClass;

+ (BOOL)allowsReverseTransformation;

@end
