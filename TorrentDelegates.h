//
//  TorrentDelegate.h
//  mrtorrent
//
//  Created by Will Goring on 17/03/2010.
//  Copyright 2010 Yell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol RateModelDelegate
- (void)didUpdateRates;
@end
