//
//  OtherProfileViewController.h
//  Eclipse
//
//  Created by Mark Meyer on 12/28/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)setUserID:(NSString*)userID;
@end
