//
//  CreateChatViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 12/7/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "CreateChatViewController.h"

#import <Parse/Parse.h>

#import "UIColor+Eclipse.h"
#import "UIImage+StackBlur.h"

#import "LocationHelper.h"

@interface CreateChatViewController ()
@property (strong, nonatomic) NSArray *EclipseColors;
@property (nonatomic) NSUInteger colorIndex;
@property (strong, nonatomic) FDTakeController *takeController;
@property (strong, nonatomic) UIImage *backgroundImage;
@end

@implementation CreateChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CREATE A CONVERSATION";
    
    self.EclipseColors = @[[UIColor eclipseDarkBlueColor], [UIColor eclipseYellowColor], [UIColor eclipseMagentaColor], [UIColor eclipseLightBlueColor], [UIColor eclipseRedColor]];
    self.colorIndex = 0;
    
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    
    UIImage *backBtn = [UIImage imageNamed:@"Close"];
    backBtn = [backBtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.backBarButtonItem.title=@"";
    self.navigationController.navigationBar.backIndicatorImage = backBtn;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backBtn;
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

- (IBAction)cameraTapped:(id)sender {
    [self.takeController takePhotoOrChooseFromLibrary];
    for (UIView *subView in self.titleTextView.subviews)
    {
        if (subView.tag == 101) {
            [subView removeFromSuperview];
        }
    }
}

- (IBAction)refreshTapped:(id)sender {
    self.colorIndex++;
    self.colorIndex = self.colorIndex%[self.EclipseColors count];
    self.titleTextView.backgroundColor = [self.EclipseColors objectAtIndex:self.colorIndex];
}

- (IBAction)postTapped:(id)sender {
    if ([self.titleTextView.text isEqualToString:@""] == NO && [self.titleTextView.text isEqualToString:@"NAME YOUR CONVERSATION"] == NO) {
        
        
        
        PFFile *filePicture = nil;
        if (self.backgroundImage != nil)
        {
            filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(self.backgroundImage, 0.6)];
            [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (error != nil) NSLog(@"sendMessage picture save error.");
             }];
        }

        PFObject *chatRoom = [PFObject objectWithClassName:@"ChatRoom"];
        chatRoom[@"Name"] = self.titleTextView.text;
        chatRoom[@"creator"] = [PFUser currentUser];
        chatRoom[@"centerPoint"] = [[LocationHelper sharedLocationHelper] getLastGeoPoint];

        const CGFloat* components;
        components = CGColorGetComponents(((UIColor*)[self.EclipseColors objectAtIndex:self.colorIndex]).CGColor);
        int hexValue = 0xFF0000*components[0] + 0xFF00*components[1] + 0xFF*components[2];
        chatRoom[@"color"] = [NSNumber numberWithInt:hexValue];

        if (filePicture != nil) chatRoom[@"picture"] = filePicture;
        [chatRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
         if (error == nil) {
             [self.navigationController popViewControllerAnimated:YES];
         }
         else {
             //[ProgressHUD showError:@"Network error."];
         }
        }];
    }
}

- (IBAction)communityGuidelinesTapped:(id)sender {
    //TODO: Open webview to guidelines
}

- (IBAction)privacyTapped:(id)sender {
    //TODO: Open webview to privacy
}

#pragma mark - UITextViewDelegate
- (void) textViewDidBeginEditing:(UITextView *) textView {
    [textView setText:@""];
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    UIImage *blurredImage = [croppedImage stackBlur:20];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame: self.titleTextView.bounds];
    self.backgroundImage = blurredImage;
    imgView.image = blurredImage;
    imgView.tag = 101;
    [self.titleTextView addSubview: imgView];
    [self.titleTextView sendSubviewToBack: imgView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
{
    CGFloat viewWidth = CGRectGetWidth(controller.view.frame);
    CGFloat viewHeight = CGRectGetHeight(controller.view.frame);
    
    CGSize maskSize = CGSizeMake(viewWidth, viewWidth/2);
    
    CGRect maskRect = CGRectMake((viewWidth - maskSize.width) * 0.5f,
                                 (viewHeight - maskSize.height) * 0.5f,
                                 maskSize.width,
                                 maskSize.height);
    
    return maskRect;
}

- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
{
    return [UIBezierPath bezierPathWithRect:controller.maskRect];
}

#pragma mark - FDTakeControllerDelegate

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:photo];
    imageCropVC.delegate = self;
    imageCropVC.dataSource = self;
    imageCropVC.cropMode = RSKImageCropModeCustom;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    /*
    CGRect clippedRect = CGRectMake((photo.size.width - 960) / 2, (photo.size.height - 600) / 2, 960, 600);
    
    // Crop logic
    CGImageRef imageRef = CGImageCreateWithImageInRect([photo CGImage], clippedRect);
    UIImage * croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    UIImage *blurredImage = [croppedImage stackBlur:20];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame: self.titleTextView.bounds];
    self.backgroundImage = blurredImage;
    imgView.image = blurredImage;
    imgView.tag = 101;
    [self.titleTextView addSubview: imgView];
    [self.titleTextView sendSubviewToBack: imgView];
        */
}
@end
