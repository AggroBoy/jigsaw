//
//  MainView.h
//  mrtorrent
//
//  Created by Will Goring on 06/12/2009.
//

#import <Cocoa/Cocoa.h>
#import <XMLRPC/XMLRPC.h>
#import "TorrentCell.h"
#import "TorrentListModel.h"
#import "RateModel.h"

@interface MainView : NSObject {
	IBOutlet TorrentListModel *torrentListModel;
	IBOutlet RateModel *rateModel;
	
	NSTimer *timer;

	bool waiting;
}

@end
