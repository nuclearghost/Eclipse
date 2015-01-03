//
//  ChatRoomTableViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 11/2/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "ChatRoomTableViewController.h"

#import <Parse/Parse.h>

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "LocationHelper.h"
#import "UIColor+Eclipse.h"
#import "ShareManager.h"

@interface ChatRoomTableViewController ()

@property (strong, nonatomic) NSMutableArray *chatRooms;

@end

@implementation ChatRoomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;

    self.chatRooms = [[NSMutableArray alloc] init];

    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName : [UIFont fontWithName:@"DINCondensed-Bold" size:20]
                                                                      }];
    
    [[LocationHelper sharedLocationHelper] startLocationServices];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ShareManager *sm = [ShareManager sharedShareManager];
    if (sm.roomId && ![sm.roomId isEqualToString:@""]) {
        PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
        [query whereKey:@"objectId" equalTo:sm.roomId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *room = objects[0];
            sm.roomId = nil;
            [self performSegueWithIdentifier:@"roomSegue" sender:room];
        }];
    } else {
        [self loadChats];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatRooms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *chatRoom = [self.chatRooms objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [chatRoom[@"Name"] uppercaseString];

    PFGeoPoint *chatPoint = chatRoom[@"centerPoint"];
    PFGeoPoint *currentPoint = [[LocationHelper sharedLocationHelper] getLastGeoPoint];
    cell.distanceLabel.text = [NSString stringWithFormat:@"%.2f km", [currentPoint distanceInKilometersTo:chatPoint]];

    NSNumber *userCount = chatRoom[@"userCount"];
    cell.peopleLabel.text = [NSString stringWithFormat:@"%@ people", userCount];

    if (chatRoom[@"color"] != nil) {
        cell.contentView.backgroundColor = UIColorFromRGB([chatRoom[@"color"] intValue]);
    }

    if (chatRoom[@"picture"] != nil) {
        
        PFFile *filePicture = chatRoom[@"picture"];
        [filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (error == nil)
             {
                 cell.backgroundImageView.image = [UIImage imageWithData:imageData];
                 [UIView animateWithDuration:1.5 animations:^{
                     cell.backgroundImageView.alpha = 1.0;
                 }];
             }
         }];
    } else {
        cell.backgroundImageView.alpha = 0;
        cell.backgroundImageView.image = nil;
    }
    
    if (chatRoom[@"expiresAt"] != nil) {
        NSDate *expiration = chatRoom[@"expiresAt"];
        NSTimeInterval seconds = [expiration timeIntervalSinceDate:[NSDate date]];
        double hours = floor(seconds/3600);
        double minutes = floor(((int)seconds % 3600)/60);
        cell.timeLabel.text = [NSString stringWithFormat:@"%2.0fh:%2.0fm", hours, minutes];
    }
    
    cell.shareBtn.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *chatroom = self.chatRooms[indexPath.row];
    [self performSegueWithIdentifier:@"roomSegue" sender:chatroom];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"roomSegue"]) {
        ChatViewController *cvc = (ChatViewController *)[segue destinationViewController];
        cvc.room = (PFObject *)sender;
    }
}


#pragma mark - UIBarButton Action

- (IBAction)addTapped:(id)sender {
    [self performSegueWithIdentifier:@"createConvoSegue" sender:nil];
}

- (IBAction)shareTapped:(UIButton *)sender {
    PFObject *chatroom = self.chatRooms[sender.tag];
    NSString *text = @"Join the conversation with Near.";
    NSURL *shareURL = [NSURL URLWithString:[NSString stringWithFormat:@"nearapp://room/%@", chatroom.objectId]];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                            initWithActivityItems:@[text, shareURL]
                                                            applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAddToReadingList];

    [self presentViewController:activityViewController
                                       animated:YES
                                     completion:^{
                                         //
                                     }];
}

#pragma mark - Private Methods
- (void)loadChats {
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    //[query whereKey:@"centerPoint" nearGeoPoint:[[LocationHelper sharedLocationHelper] getLastGeoPoint] withinMiles:3.5];
    [query whereKey:@"active" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [self.chatRooms removeAllObjects];
             for (PFObject *object in objects)
             {
                 [self.chatRooms addObject:object];
             }
             [self.tableView reloadData];
         }
         else {
             //TODO: Display message
         }
     }];

}
@end
