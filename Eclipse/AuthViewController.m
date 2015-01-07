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

#import "UIColor+Eclipse.h"

@interface AuthViewController ()

@end

@implementation AuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)usePhoneNumberTapped:(id)sender {
    DGTAppearance *digitsAppearance = [[DGTAppearance alloc] init];
    digitsAppearance.backgroundColor = [UIColor eclipseGrayColor];
    digitsAppearance.accentColor = [UIColor whiteColor];
    
    Digits *digits = [Digits sharedInstance];
    [digits authenticateWithDigitsAppearance:digitsAppearance viewController:nil title:nil completion:^(DGTSession *session, NSError *error) {
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
            NSString *errorString = [error userInfo][@"error"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }];
}
@end
