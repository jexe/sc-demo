//
//  TrackSummaryCell.h
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/16/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTrackCellHeight 100.0F

@class RemoteImageView;

@interface TrackSummaryCell : UITableViewCell {
    UIImageView *_waveForm;
    UILabel *_title;
    UILabel *_creationDate;
}

+ (TrackSummaryCell *)cellForTable:(UITableView *)tableView data:(NSDictionary *)dict;

@end
