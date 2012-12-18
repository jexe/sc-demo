//
//  ViewController.m
//  SoundCloudDemo
//
//  Created by Jesse Boyes on 12/11/12.
//  Copyright (c) 2012 Jesse Boyes. All rights reserved.
//

#import "ViewController.h"
#import <SCUI.h>
#import <QuartzCore/QuartzCore.h>
#import "TrackSummaryCell.h"

#define kSoundCloudFavoritesLoadURL  @"https://api.soundcloud.com/me/favorites.json"

#define kHeaderHeight 50.0

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Track listing
    _trackTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    _trackTable.dataSource = self;
    _trackTable.delegate = self;
    _trackTable.scrollIndicatorInsets = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    [self.view addSubview:_trackTable];

    // Header and logout button
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kHeaderHeight)];
    header.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];

    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    logoutButton.frame = CGRectMake(header.bounds.size.width - 80.0, 5.0, 70.0, kHeaderHeight-10.0);
    [logoutButton setTintColor:[UIColor grayColor]];
    [logoutButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [logoutButton setTitle:@"Sign out" forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(logoutPressed:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:logoutButton];

    UILabel *title = [[UILabel alloc] initWithFrame:header.bounds];
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = UITextAlignmentCenter;
    title.text = @"★ Favorites";
    [header addSubview:title];

    [self.view addSubview:header];
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
        [self login:animated];
    } else {
        [self loadTracks];
    }
}

#pragma mark - our UI

- (void)logoutPressed:(id)sender
{
    [SCSoundCloud removeAccess];
    _tracks = nil;
    [_trackTable reloadData];
    [self login:YES];
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

- (void)login:(BOOL)animated
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
                                animated:animated];
        
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

// Create a header for TableView top padding.
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [TrackSummaryCell cellForTable:tableView data:[_tracks objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *data = [_tracks objectAtIndex:indexPath.row];

    // Attempt to open the app, fall back to the site
    UIApplication *app = [UIApplication sharedApplication];
    NSURL *appLaunchURL = [NSURL URLWithString:[NSString stringWithFormat:@"soundcloud:track:%@", [data objectForKey:@"id"]]];

    if ([app canOpenURL:appLaunchURL]) {
        [app openURL:appLaunchURL];
    } else {
        [app openURL:[NSURL URLWithString:[data objectForKey:@"permalink_url"]]];
    }
}


@end
