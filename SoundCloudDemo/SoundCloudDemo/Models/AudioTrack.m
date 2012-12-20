//
//  AudioTrack.m
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/20/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import "AudioTrack.h"

@implementation AudioTrack

- (id)initWithData:(NSDictionary *)data
{
    static NSDateFormatter *s_dateFormatter = nil;

    self = [super init];

    if (self) {
        self.soundCloudSiteURL = [NSURL URLWithString:[data objectForKey:@"permalink_url"]];
        self.avatarURL = [NSURL URLWithString:[[data objectForKey:@"user"] objectForKey:@"avatar_url"]];
        self.waveformImageURL = [NSURL URLWithString:[data objectForKey:@"waveform_url"]];
        self.title = [data objectForKey:@"title"];
        self.trackID = [data objectForKey:@"id"];

        if (!s_dateFormatter) {
            s_dateFormatter = [[NSDateFormatter alloc] init];
            [s_dateFormatter setDateFormat:@"yyyy/MM/dd' 'HH:mm:ss' 'ZZZZ"];
        }
        self.creationDate = [s_dateFormatter dateFromString:[data objectForKey:@"created_at"]];
    }
    return self;
}

- (NSURL *)appLaunchURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"soundcloud:track:%@", self.trackID]];
}

@end
