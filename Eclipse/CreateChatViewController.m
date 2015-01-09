//
//  CreateChatViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 12/7/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "CreateChatViewController.h"

#import <Parse/Parse.h>

#import "TOWebViewController.h"

#import "UIColor+Eclipse.h"
#import "UIImageEffects.h"

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
    self.title = @"CREATE A CONVERSATION";
    
    self.EclipseColors = @[[UIColor eclipseMedGrayColor], [UIColor eclipseDarkBlueColor], [UIColor eclipseYellowColor], [UIColor eclipseMagentaColor], [UIColor eclipseLightBlueColor], [UIColor eclipseRedColor]];
    self.colorIndex = -1;
    [self refreshTapped:nil];
    
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    

    self.titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"NAME YOUR CONVERSATION" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.titleTextField.delegate = self;
    
    UIImage *backBtn = [UIImage imageNamed:@"Close"];
    backBtn = [backBtn imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.backBarButtonItem.title=@"";
    self.navigationController.navigationBar.backIndicatorImage = backBtn;
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backBtn;
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    [self.guidelinesButton setAttributedTitle: [[NSAttributedString alloc] initWithString:@"Community Guidelines"
                                                                               attributes:underlineAttribute] forState:UIControlStateNormal];
    [self.privacyButton setAttributedTitle: [[NSAttributedString alloc] initWithString:@"Privacy Policy"
                                                                               attributes:underlineAttribute] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.hidesBarsOnSwipe = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cameraTapped:(id)sender {
    [self.takeController takePhotoOrChooseFromLibrary];
}

- (IBAction)refreshTapped:(id)sender {
    self.colorIndex++;
    self.colorIndex = self.colorIndex%[self.EclipseColors count];
    self.titleTextView.backgroundColor = [self.EclipseColors objectAtIndex:self.colorIndex];
}

- (IBAction)postTapped:(id)sender {
    if ([self.titleTextField.text isEqualToString:@""] == NO && [self.titleTextField.text isEqualToString:@"NAME YOUR CONVERSATION"] == NO) {
        
        self.postButton.enabled = NO;
        
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
        chatRoom[@"Name"] = self.titleTextField.text;
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
         } else {
             self.postButton.enabled = YES;
         }
        }];
    }
}

- (IBAction)communityGuidelinesTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://imnear.wordpress.com/2015/01/08/community-guidelines/"];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
}

- (IBAction)privacyTapped:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://imnear.wordpress.com/2015/01/08/privacy-policy/"];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage
{
    for (UIView *subView in self.titleTextView.subviews)
    {
        if (subView.tag == 101) {
            [subView removeFromSuperview];
            break;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
    UIImage *blurredImage = [UIImageEffects imageByApplyingBlurToImage:croppedImage withRadius:25 tintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] saturationDeltaFactor:1.0 maskImage:nil];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame: self.titleTextView.bounds];
    self.backgroundImage = blurredImage;
    imgView.image = blurredImage;
    imgView.tag = 101;
    
    [self.titleTextView addSubview: imgView];
    [self.titleTextView sendSubviewToBack: imgView];
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
}
@end
