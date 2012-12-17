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
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor darkGrayColor];

        _waveForm = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, kTrackCellHeight*2)];
        [self.contentView addSubview:_waveForm];

        _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, (kTrackCellHeight - kAvatarSize)/2, kAvatarSize, kAvatarSize)];
        _avatar.clipsToBounds = YES;
        _avatar.layer.cornerRadius = 4.0;
        [self.contentView addSubview:_avatar];
    
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 20.0)];
        _title.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:0.8];//[UIColor colorWithWhite:1.0 alpha:0.5];
        _title.font = [UIFont systemFontOfSize:15.0];
        _title.textColor = [UIColor blackColor];
        [self.contentView addSubview:_title];
    }
    return self;
}

- (void)applyTrackData:(NSDictionary *)dict
{
    [_waveForm loadURL:[dict objectForKey:@"waveform_url"]];
    [_avatar loadURL:[[dict objectForKey:@"user"] objectForKey:@"avatar_url"]];
    [_title setText:[dict objectForKey:@"title"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
