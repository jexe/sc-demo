//
//  ViewController.h
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/11/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *trackTable;
    NSArray *tracks;
}

@end
