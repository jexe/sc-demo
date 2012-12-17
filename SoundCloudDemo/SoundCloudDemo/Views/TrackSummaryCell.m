//
//  TrackSummaryCell.m
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/16/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import "TrackSummaryCell.h"
#import "UIImageView+URLLoader.h"

#define kTrackCellIdent @"SCTrackCell"

@implementation TrackSummaryCell

+ (TrackSummaryCell *)cellForTable:(UITableView *)tableView data:(NSDictionary *)dict
{
    TrackSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrackCellIdent];
    if (!cell) {
        cell = [[TrackSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:kTrackCellIdent];
    }

    [cell applyTrackData:dict];
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _waveForm = [[UIImageView alloc] initWithFrame:self.bounds];
        _waveForm.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)applyTrackData:(NSDictionary *)dict
{
    [_waveForm loadURL:[dict objectForKey:@"waveform_url"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
