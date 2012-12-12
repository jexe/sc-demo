//
//  ViewController.m
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/11/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import "ViewController.h"
#import <SCUI.h>

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![SCSoundCloud account]) {
        [self login];
    }
}

#pragma mark - our UI

- (void)logoutPressed
{
    [SCSoundCloud removeAccess];
    [self login];
}

#pragma mark - SoundCloud UI hooks

- (void)userSignedIn
{
    // Retrieve a list of user favorites
    
}

- (void)login;
{
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        
        SCLoginViewController *loginViewController;
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                      completionHandler:^(NSError *error){
                                                                          
                                                                          if (SC_CANCELED(error)) {
                                                                              NSLog(@"Canceled!");
                                                                          } else if (error) {
                                                                              NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                                                          } else {
                                                                              NSLog(@"Done!");
                                                                          }
                                                                      }];
        
        [self presentModalViewController:loginViewController
                                animated:YES];
        
    }];
}



@end
