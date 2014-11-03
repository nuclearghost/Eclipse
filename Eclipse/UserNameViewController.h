//
//  UserNameViewController.h
//  Eclipse
//
//  Created by Mark Meyer on 11/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserNameViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameField;

- (IBAction)checkAvailabilityTapped:(id)sender;

@end
