//
//  ChatViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 11/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "ChatViewController.h"

#import "UIColor+Eclipse.h"

@interface ChatViewController ()
{
    NSTimer *timer;
    BOOL isLoading;
    
    NSMutableArray *users;
    NSMutableArray *messages;
    NSMutableDictionary *avatars;
    
    JSQMessagesBubbleImage *outgoingBubbleImageData;
    JSQMessagesBubbleImage *incomingBubbleImageData;
    
    JSQMessagesAvatarImage *placeholderImageData;
    
    FDTakeController *takeController;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.room[@"Name"];
    
    users = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    avatars = [[NSMutableDictionary alloc] init];
    
    PFUser *user = [PFUser currentUser];
    self.senderId = user.objectId;
    self.senderDisplayName = user[@"username"];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] initWithBubbleImage:[UIImage imageNamed:@"Chat_Square"] capInsets:UIEdgeInsetsZero];
    outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor eclipseGrayColor]];
    incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor eclipseLightGrayColor]];
    
    placeholderImageData = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"User"] diameter:30.0];
    
    takeController = [[FDTakeController alloc] init];
    takeController.delegate = self;
    
    isLoading = NO;
    [self loadMessages];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [timer invalidate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    [self sendMessage:text Picture:nil];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    [takeController takePhotoOrChooseFromLibrary];
}

#pragma mark - FDTakeControllerDelegate

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    [self sendMessage:@"" Picture:photo];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId])
    {
        return outgoingBubbleImageData;
    }
    return incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *user = users[indexPath.item];
    if (avatars[user.objectId] == nil)
    {
        PFFile *fileThumbnail = user[@"thumbnail"];
        [fileThumbnail getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (error == nil)
             {
                 avatars[user.objectId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithData:imageData] diameter:30.0];
                 [self.collectionView reloadData];
             }
         }];
        return placeholderImageData;
    }
    else return avatars[user.objectId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0)
    {
        JSQMessage *message = messages[indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId])
    {
        return nil;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = messages[indexPath.item-1];
        if ([previousMessage.senderId isEqualToString:message.senderId])
        {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId])
    {
        return nil;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = messages[indexPath.item-1];
        if ([previousMessage.senderId isEqualToString:message.senderId])
        {
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

#pragma mark - UICollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return [messages count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId])
    {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.textView.textColor = [UIColor blackColor];
    }
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.item % 3 == 0)
    {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId])
    {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0)
    {
        JSQMessage *previousMessage = messages[indexPath.item-1];
        if ([previousMessage.senderId isEqualToString:message.senderId])
        {
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
    return 0.0f;
}

#pragma mark - Private


- (void)sendMessage:(NSString *)text Picture:(UIImage *)picture
{
    PFFile *filePicture = nil;
    if (picture != nil)
    {
        filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
        [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error != nil) NSLog(@"sendMessage picture save error.");
         }];
    }
    PFObject *object = [PFObject objectWithClassName:@"Chat"];
    object[@"user"] = [PFUser currentUser];
    object[@"room"] = self.room;
    object[@"text"] = text;
    if (filePicture != nil) object[@"picture"] = filePicture;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [JSQSystemSoundPlayer jsq_playMessageSentSound];
             [self loadMessages];
         }
         else {
             //[ProgressHUD showError:@"Network error."];
         }
     }];
    //SendPushNotification(roomId, text);
    //UpdateMessageCounter(roomId, text);
    [self finishSendingMessage];
}

- (void)loadMessages
{
    if (isLoading == NO)
    {
        isLoading = YES;
        JSQMessage *message_last = [messages lastObject];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
        [query whereKey:@"room" equalTo:self.room];
        if (message_last != nil) [query whereKey:@"createdAt" greaterThan:message_last.date];
        [query includeKey:@"user"];
        [query orderByDescending:@"createdAt"];
        [query setLimit:50];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {
             if (error == nil)
             {
                 for (PFObject *object in [objects reverseObjectEnumerator])
                 {
                     [self addMessage:object];
                 }
                 if ([objects count] != 0) [self finishReceivingMessage];
             }
             else {
                 //[ProgressHUD showError:@"Network error."];
             }
             isLoading = NO;
         }];
    }
}

- (void)addMessage:(PFObject *)object
{
    PFUser *user = object[@"user"];
    [users addObject:user];
    if (object[@"picture"] == nil)
    {
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:user[@"username"]
                                                                      date:object.createdAt text:object[@"text"]];
        [messages addObject:message];
    }
    if (object[@"picture"] != nil)
    {
        JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:user[@"username"]
                                                                        date:object.createdAt media:mediaItem];
        [messages addObject:message];
        PFFile *filePicture = object[@"picture"];
        [filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (error == nil)
             {
                 mediaItem.image = [UIImage imageWithData:imageData];
                 [self.collectionView reloadData];
             }
         }];
    }
}
@end
