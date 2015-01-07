//
//  BetaCodeViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 1/6/15.
//  Copyright (c) 2015 Mark Meyer. All rights reserved.
//

#import "BetaCodeViewController.h"

#import <Parse/Parse.h>

@interface BetaCodeViewController ()

@end

@implementation BetaCodeViewController

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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self checkAccessCode];
    return YES;
}

#pragma mark - private
- (void)checkAccessCode {
    [PFCloud callFunctionInBackground:@"checkAccessCode"
                       withParameters:@{@"accessCode": self.accessCodeTextField.text}
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                        NSLog(@"Perform Segue");
                                    } else {
                                        NSString *errorString = [error userInfo][@"error"];
                                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                        [av show];
                                    }
                                }];
}

@end
