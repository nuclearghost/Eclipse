//
//  MyProfileViewController.h
//  Eclipse
//
//  Created by Mark Meyer on 12/22/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FDTakeController.h>
#import <RSKImageCropViewController.h>

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@interface MyProfileViewController : UIViewController <FDTakeDelegate, UIAlertViewDelegate, RSKImageCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *profileImgButton;
@property (weak, nonatomic) IBOutlet UILabel *profileStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIButton *statusButton;
@property (weak, nonatomic) IBOutlet UIButton *passwordButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;

- (IBAction)profileImgTapped:(id)sender;
- (IBAction)changeStatusTapped:(id)sender;
- (IBAction)changePasswordTapped:(id)sender;
- (IBAction)changePictureTapped:(id)sender;

@end
