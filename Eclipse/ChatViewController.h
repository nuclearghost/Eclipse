//
//  ChatViewController.h
//  Eclipse
//
//  Created by Mark Meyer on 11/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <Parse/Parse.h>

#import "JSQMessagesViewController.h"
#import "JSQMessages.h"
#import "FDTakeController.h"


@interface ChatViewController : JSQMessagesViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, FDTakeDelegate, JSQMessagesCollectionViewCellDelegate>

@property (strong, nonatomic) PFObject *room;

- (IBAction)shareTapped:(id)sender;

@end
