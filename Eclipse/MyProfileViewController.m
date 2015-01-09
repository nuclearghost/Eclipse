//
//  MyProfileViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 12/22/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "MyProfileViewController.h"

#import <Parse/Parse.h>
#import <ImageIO/ImageIO.h>



@interface MyProfileViewController ()

@property (strong, nonatomic) FDTakeController *takeController;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFUser *user = [PFUser currentUser];

    self.usernameLabel.text = user[@"username"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"DINCondensed-Bold" size:20]
                                                                      }];
    self.profileStatusLabel.text = user[@"status"];
    self.profileImgButton.imageView.layer.cornerRadius = self.profileImgButton.frame.size.width / 2;

    PFFile *pictureFile = user[@"picture"];
    [pictureFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
     {
         if (error == nil)
         {
             [self.profileImgButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
         }
     }];

    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    
    CGFloat cornerRadius = 20;
    self.statusButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.statusButton.layer.borderWidth = 1.0;
    self.statusButton.layer.cornerRadius = cornerRadius;
    self.passwordButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.passwordButton.layer.borderWidth = 1.0;
    self.passwordButton.layer.cornerRadius = cornerRadius;
    self.pictureButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.pictureButton.layer.borderWidth = 1.0;
    self.pictureButton.layer.cornerRadius = cornerRadius;

    UIImage *backBtn = [UIImage imageNamed:@"BackArrow"];
    backBtn = [backBtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.backBarButtonItem.title=@"";
    self.navigationController.navigationBar.backIndicatorImage = backBtn;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)profileImgTapped:(id)sender {
    [self.takeController takePhotoOrChooseFromLibrary];
}

- (IBAction)changeStatusTapped:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Set Status"
                                                     message:@"Enter your status"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Change", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 100;
    [alert show];
}

- (IBAction)changePasswordTapped:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Change Password"
                                                     message:@"Enter a new password"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Change", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.tag = 101;
    [alert show];
}

- (IBAction)changePictureTapped:(id)sender {
    [self.takeController takePhotoOrChooseFromLibrary];
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    PFFile *filePicture = nil;
    filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(croppedImage, 0.6)];
    [filePicture saveInBackground];
    PFUser *user = [PFUser currentUser];
    user[@"picture"] = filePicture;
    self.profileImgButton.imageView.layer.cornerRadius = self.profileImgButton.frame.size.width / 2;
    [self.profileImgButton setImage:croppedImage forState:UIControlStateNormal];
    
    CGSize size = CGSizeMake(360, 360);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [croppedImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    PFFile *fileThumb = nil;
    fileThumb = [PFFile fileWithName:@"thumb.jpg" data:UIImageJPEGRepresentation(scaledImage, 0.6)];
    [fileThumb saveInBackground];
    user[@"thumbnail"] = fileThumb;
    
    [user saveInBackground];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FDTakeControllerDelegate

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    ALog(@"");
    if (buttonIndex == 1) {
        if (alertView.tag == 101) {
            PFUser *user = [PFUser currentUser];
            user.password = [[alertView textFieldAtIndex:0] text];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:user.password forKey:@"password"];
            [user saveInBackground];
        }
        else if (alertView.tag == 100) {
            PFUser *user = [PFUser currentUser];
            user[@"status"] = [[alertView textFieldAtIndex:0] text];
            [user saveInBackground];
            self.profileStatusLabel.text = [[alertView textFieldAtIndex:0] text];
        }
    }
}
@end
