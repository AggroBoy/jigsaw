//
//  TorrentDelegate.h
//  mrtorrent
//
//  Created by Will Goring on 17/03/2010.
//

#import <Cocoa/Cocoa.h>


@protocol RateModelDelegate
- (void)didUpdateRates;
@end
