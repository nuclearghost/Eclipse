//
//  BetaCodeViewController.h
//  Eclipse
//
//  Created by Mark Meyer on 1/6/15.
//  Copyright (c) 2015 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BetaCodeViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accessCodeTextField;

@end
