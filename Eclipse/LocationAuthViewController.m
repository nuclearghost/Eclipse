//
//  LocationAuthViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 1/6/15.
//  Copyright (c) 2015 Mark Meyer. All rights reserved.
//

#import "LocationAuthViewController.h"

#import <Parse/Parse.h>

@interface LocationAuthViewController ()

@end

@implementation LocationAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapped:(id)sender {
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {}];
    [self performSegueWithIdentifier:@"locationToNotificationSegue" sender:nil];
}

- (IBAction)laterTapped:(id)sender {
    [self performSegueWithIdentifier:@"locationToNotificationSegue" sender:nil];
}
@end
