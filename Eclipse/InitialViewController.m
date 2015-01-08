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
    
    NSDictionary *dict = @{@"320x480" : @"LaunchImage-700", @"320x568" : @"LaunchImage-700-568h", @"375x667" : @"LaunchImage-800-667h", @"414x736" : @"LaunchImage-800-Portrait-736h"};
    NSString *key = [NSString stringWithFormat:@"%dx%d", (int)[UIScreen mainScreen].bounds.size.width, (int)[UIScreen mainScreen].bounds.size.height];
    UIImage *launchImage = [UIImage imageNamed:dict[key]];
    self.mainImageView.image = launchImage;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:@"userName"];
    NSString *secret = [defaults objectForKey:@"password"];
    if (userName == nil || secret == nil) {
        [self segueToAuth];
    } else {
        [PFUser logInWithUsernameInBackground:userName password:secret
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
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
    [self performSegueWithIdentifier:@"signupSegue" sender:nil];
}
@end
