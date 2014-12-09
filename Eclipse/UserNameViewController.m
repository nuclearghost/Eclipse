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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)checkAvailabilityTapped:(id)sender {
    [self.userNameField endEditing:YES];

    [self createUser];
}

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
            // Hooray! Let them use the app now.
//            [self performSegueWithIdentifier:@"userNameRoomSegue" sender:nil];
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
