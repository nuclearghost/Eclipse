//
//  CreateChatViewController.h
//  Eclipse
//
//  Created by Mark Meyer on 12/7/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FDTakeController.h"
#import "RSKImageCropViewController.h"

@interface CreateChatViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate, FDTakeDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

- (IBAction)cameraTapped:(id)sender;
- (IBAction)refreshTapped:(id)sender;
- (IBAction)postTapped:(id)sender;
- (IBAction)communityGuidelinesTapped:(id)sender;
- (IBAction)privacyTapped:(id)sender;

@end
