//
//  AudioTrack.h
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/20/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioTrack : NSObject

@property (readonly) NSString *trackID;
@property (readonly) NSString *title;
@property (readonly) NSURL *waveformImageURL;
@property (readonly) NSURL *avatarURL;
@property (readonly) NSURL *soundCloudSiteURL;
@property (readonly) NSURL *appLaunchURL;
@property (readonly) NSDate *creationDate;

- (AudioTrack *)initWithData:(NSDictionary *)data;

@end
