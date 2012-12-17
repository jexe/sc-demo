//
//  ViewController.m
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/11/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import "ViewController.h"
#import <SCUI.h>
#import "TrackSummaryCell.h"

#define kSoundCloudFavoritesLoadURL  @"https://api.soundcloud.com/me/favorites.json"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;

    _trackTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    _trackTable.dataSource = self;
    _trackTable.delegate = self;
    [self.view addSubview:_trackTable];
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
    } else {
        [self loadTracks];
    }
}

#pragma mark - our UI

- (void)logoutPressed
{
    [SCSoundCloud removeAccess];
    [self login];
}

#pragma mark - SoundCloud hooks

- (void)loadTracks
{
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:kSoundCloudFavoritesLoadURL]
             usingParameters:nil
                 withAccount:[SCSoundCloud account]
      sendingProgressHandler:nil
             responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                 NSError *jsonError = nil;
                 NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                                      JSONObjectWithData:data
                                                      options:0
                                                      error:&jsonError];
                 if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
                     NSLog(@"Success! %@", jsonResponse);
                     _tracks = (NSArray *)jsonResponse;
                     [_trackTable reloadData];
                 } else {
                     NSLog(@"Error decoding JSON response: %@ / Data: %@", jsonError, jsonResponse);
                 }
                 
             }];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tracks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTrackCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TrackSummaryCell cellForTable:tableView data:[_tracks objectAtIndex:indexPath.row]];
}


@end
