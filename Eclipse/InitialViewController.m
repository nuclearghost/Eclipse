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
    NSString *secret = [defaults objectForKey:@"password"];
    if (userName == nil || secret == nil) {
        [self segueToAuth];
    } else {
        [PFUser logInWithUsernameInBackground:userName password:secret
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                //TODO remove this after 12/15/2014
                                                [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
                                                [[PFInstallation currentInstallation] saveEventually];
                                                [self performSegueWithIdentifier:@"chatMenuSegue" sender:nil];

                                            } else {
                                                CLS_LOG(@"Error from login: %@", error);
                                                NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
                                                [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
                                                [self segueToAuth];
                                            }
                                        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segueToAuth {
    [self performSegueWithIdentifier:@"authSegue" sender:nil];
}
@end
