//
//  RemoteImageView.h
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/16/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import <UIKit/UIKit.h>

/* Category used for loading images remotely for UIImages */

@interface UIImageView (URLLoader)

- (void)loadURL:(NSString *)path;
@end
