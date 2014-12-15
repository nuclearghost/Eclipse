//
//  InitialViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 11/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "InitialViewController.h"

#import <Parse/Parse.h>
#import <Crashlytics/Crashlytics.h>

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    if (userName == nil) {
        [self performSegueWithIdentifier:@"authSegue" sender:nil];
    } else {
        NSString *secret = [defaults objectForKey:@"digitsAuthTokenSecret"];
        [PFUser logInWithUsernameInBackground:userName password:secret
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                //TODO remove this after 12/15/2014
                                                [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
                                                [[PFInstallation currentInstallation] saveEventually];
                                                [self performSegueWithIdentifier:@"chatMenuSegue" sender:nil];

                                            } else {
                                                CLS_LOG(@"Error from login: %@", error);
                                            }
                                        }];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
