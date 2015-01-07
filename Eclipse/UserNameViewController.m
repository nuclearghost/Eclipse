//
//  UserNameViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 11/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "UserNameViewController.h"

#import <Parse/Parse.h>

@interface UserNameViewController ()

@end

@implementation UserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self createUser];
    return YES;
}

#pragma mark - Private

- (void)createUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *userName = self.userNameField.text;
    
    PFUser *user = [PFUser user];
    user.username = userName;
    user.password = [defaults objectForKey:@"digitsAuthTokenSecret"];
    user[@"digitsPhoneNumber"] = [defaults objectForKey:@"digitsPhoneNumber"];
    user[@"digitsID"] = [defaults objectForKey:@"digitsID"];
    user[@"digitsAuthToken"] = [defaults objectForKey:@"digitsAuthToken"];

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [[PFInstallation currentInstallation] setObject:[PFUser currentUser] forKey:@"user"];
            [[PFInstallation currentInstallation] saveEventually];

            [self performSegueWithIdentifier:@"userNameMenuSegue" sender:nil];
            
            [defaults setObject:userName forKey:@"userName"];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }];
}
@end
