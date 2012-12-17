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

    trackTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    trackTable.dataSource = self;
    trackTable.delegate = self;
    [self.view addSubview:trackTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    SCAccount *account = [SCSoundCloud account];

    if (!account) {
        [self login];
    } else {
        NSString *resourceURL = @"https://api.soundcloud.com/me/favorites.json";
        [SCRequest performMethod:SCRequestMethodGET
                      onResource:[NSURL URLWithString:resourceURL]
                 usingParameters:nil
                     withAccount:account
          sendingProgressHandler:nil
                 responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                     NSError *jsonError = nil;
                     NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                                          JSONObjectWithData:data
                                                          options:0
                                                          error:&jsonError];
                     if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
                         NSLog(@"Success! %@", jsonResponse);
                         tracks = (NSArray *)jsonResponse;
                         [trackTable reloadData];
                     } else {
                         NSLog(@"Error decoding JSON response: %@ / Data: %@", jsonError, jsonResponse);
                     }

                 }];

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

#pragma mark - UITableViewDelegate and UITableViewDataSource methods

#define kCellIdent @"SCTrackCell"

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdent];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdent];
    }

    return cell;
}


@end
