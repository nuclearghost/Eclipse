//
//  CreateChatViewController.h
//  Eclipse
//
//  Created by Mark Meyer on 12/7/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateChatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;

- (IBAction)cameraTapped:(id)sender;
- (IBAction)refreshTapped:(id)sender;
- (IBAction)postTapped:(id)sender;
- (IBAction)communityGuidelinesTapped:(id)sender;
- (IBAction)privacyTapped:(id)sender;

@end
