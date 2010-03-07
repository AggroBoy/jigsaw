//
//  TorrentCell.h
//  mrtorrent
//
//  Created by Will Goring on 08/12/2009.
//  Copyright 2009 Yell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TorrentCell : NSCell {
	NSDictionary *normalAttrsDictionary;
	NSDictionary *greyAttrsDictionary;
	NSDictionary *smallAttrsDictionary;
	NSDictionary *smallGreyAttrsDictionary;

}

- (void)drawInteriorWithFrame:(NSRect)theFrame inView:(NSView *)theView;

@end
