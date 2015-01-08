//
//  OtherProfileViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 12/28/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "OtherProfileViewController.h"

#import <Parse/Parse.h>

@interface OtherProfileViewController ()
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) PFObject *user;
@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.reportUserButton.layer.borderWidth = 1.0;
    self.reportUserButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reportTapped:(id)sender {
    [PFCloud callFunctionInBackground:@"reportUser"
                       withParameters:@{@"reportedUserId": self.user.objectId}
                                block:^(id object, NSError *error) {
                                    if (!error) {
                                    }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setUserID:(NSString*)userID {
    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:userID block:^(PFObject *object, NSError *error) {
         if (error == nil)
         {
             self.user = object;
             self.title = @"PROFILE";
             self.usernameLabel.text = self.user[@"username"];
             [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                               NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                               NSFontAttributeName : [UIFont fontWithName:@"DINCondensed-Bold" size:20]
                                                                               }];
             self.statusLabel.text = self.user[@"status"];
             PFFile *pictureFile = self.user[@"picture"];
             [pictureFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
              {
                  if (error == nil)
                  {
                      self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
                      self.profileImageView.clipsToBounds = YES;
                      self.profileImageView.image = [UIImage imageWithData:imageData];
                  }
              }];
         }
         else {
             //TODO: Display message
         }
     }];
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
