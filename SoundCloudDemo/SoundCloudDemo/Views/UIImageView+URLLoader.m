//
//  RemoteImageView.m
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/16/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import "UIImageView+URLLoader.h"

@implementation UIImageView (URLLoader)

- (void)loadURL:(NSURL *)url
{
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *res, NSData *data, NSError *err) {
                               if (err) {
                                   NSLog(@"Error downloading image: %@", [err localizedDescription]);
                               } else {
                                   [self performSelectorOnMainThread:@selector(setImage:)
                                                          withObject:[UIImage imageWithData:data]
                                                       waitUntilDone:NO];
                               }
                           }];
}

@end
