//
//  TrackSummaryCell.m
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/16/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import "TrackSummaryCell.h"
#import "UIImageView+URLLoader.h"
#import <QuartzCore/QuartzCore.h>

#define kTrackCellIdent @"SCTrackCell"

#define kAvatarSize 50.0

@implementation TrackSummaryCell

+ (TrackSummaryCell *)cellForTable:(UITableView *)tableView data:(NSDictionary *)dict
{
    TrackSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrackCellIdent];
    if (!cell) {
        cell = [[TrackSummaryCell alloc] initWithTableView:tableView];
    }

    [cell applyTrackData:dict];
    return cell;
}

- (id)initWithTableView:(UITableView *)tableView
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTrackCellIdent];

    if (self) {
    
        CGFloat cellWidth = tableView.bounds.size.width;

        // Layout & style components

        // Wave form
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor darkGrayColor];

        _waveForm = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, kTrackCellHeight*2)];
        [self.contentView addSubview:_waveForm];

        // User avatar
        _avatar = [[UIImageView alloc] initWithFrame:
                   CGRectMake(5.0, (kTrackCellHeight - kAvatarSize - 40)/2, kAvatarSize, kAvatarSize)];
        _avatar.clipsToBounds = YES;
        _avatar.layer.cornerRadius = 4.0;
        [self.contentView addSubview:_avatar];

        // Information bar: track name & date
        UIView *infoBar = [[UIView alloc] initWithFrame:CGRectMake(0, kTrackCellHeight-40.0, cellWidth, 40.0)];
        infoBar.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.9 alpha:0.75];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, cellWidth - 10, 20.0)];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont boldSystemFontOfSize:14.0];
        _title.textColor = [UIColor blackColor];
        [infoBar addSubview:_title];
    
        _creationDate = [[UILabel alloc] initWithFrame:CGRectMake(5, 20, cellWidth - 10, 20.0)];
        _creationDate.backgroundColor = [UIColor clearColor];
        _creationDate.font = [UIFont systemFontOfSize:14.0];
        _creationDate.textColor = [UIColor blackColor];
        [infoBar addSubview:_creationDate];

        [self.contentView addSubview:infoBar];
    }
    return self;
}

- (void)applyTrackData:(NSDictionary *)dict
{
    static NSDateFormatter *s_dateFormatter = nil;

    [_waveForm loadURL:[dict objectForKey:@"waveform_url"]];
    [_avatar loadURL:[[dict objectForKey:@"user"] objectForKey:@"avatar_url"]];
    _title.text = [dict objectForKey:@"title"];

    if (!s_dateFormatter) {
        s_dateFormatter = [[NSDateFormatter alloc] init];
        [s_dateFormatter setDateFormat:@"yyyy/MM/dd' 'HH:mm:ss' 'ZZZZ"];
    }
    NSDate *date = [s_dateFormatter dateFromString:[dict objectForKey:@"created_at"]];
    _creationDate.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
}

@end
