//
//  AudioTrack.h
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/20/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioTrack : NSObject

@property (nonatomic, retain) NSString *trackID;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *waveformImageURL;
@property (nonatomic, retain) NSURL *avatarURL;
@property (nonatomic, retain) NSURL *soundCloudSiteURL;
@property (readonly) NSURL *appLaunchURL;
@property (nonatomic, retain) NSDate *creationDate;

- (AudioTrack *)initWithData:(NSDictionary *)data;

@end
