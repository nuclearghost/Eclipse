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
    
    self.title = user[@"username"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"DINCondensed-Bold" size:20]
                                                                      }];
    self.profileStatusLabel.text = user[@"status"];
    
    PFFile *pictureFile = user[@"picture"];
    [pictureFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
     {
         if (error == nil)
         {
             self.profileImgButton.imageView.layer.cornerRadius = self.profileImgButton.frame.size.width / 2;
             [self.profileImgButton setImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
         }
     }];
    
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

#pragma mark - FDTakeControllerDelegate

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    PFFile *filePicture = nil;
    filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(photo, 0.6)];
    [filePicture saveInBackground];
    PFUser *user = [PFUser currentUser];
    user[@"picture"] = filePicture;
    self.profileImgButton.imageView.layer.cornerRadius = self.profileImgButton.frame.size.width / 2;
    [self.profileImgButton setImage:photo forState:UIControlStateNormal];
    
    CGSize size = CGSizeMake(360, 360);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [photo drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    PFFile *fileThumb = nil;
    fileThumb = [PFFile fileWithName:@"thumb.jpg" data:UIImageJPEGRepresentation(scaledImage, 0.6)];
    [fileThumb saveInBackground];
    user[@"thumbnail"] = fileThumb;
    
    [user saveInBackground];
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
