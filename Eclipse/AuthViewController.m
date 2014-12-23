//
//  AuthViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 11/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "AuthViewController.h"
#import <TwitterKit/TwitterKit.h>
#import <Crashlytics/Crashlytics.h>

@interface AuthViewController ()

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DGTAuthenticateButton *authenticateButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        
        if (session != nil) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:session.phoneNumber forKey:@"digitsPhoneNumber"];
            [defaults setObject:session.userID forKey:@"digitsID"];
            [defaults setObject:session.authToken forKey:@"digitsAuthToken"];
            [defaults setObject:session.authTokenSecret forKey:@"digitsAuthTokenSecret"];
            [defaults setObject:session.authTokenSecret forKey:@"password"];
            
            [self performSegueWithIdentifier:@"userNameSegue" sender:nil];
        } else {
            CLS_LOG(@"Error from digits: %@", error);
        }
    }];
    authenticateButton.center = self.view.center;
    [self.view addSubview:authenticateButton];

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
