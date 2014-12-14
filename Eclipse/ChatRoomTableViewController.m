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

@interface ChatRoomTableViewController ()

@property (strong, nonatomic) NSMutableArray *chatRooms;

@end

@implementation ChatRoomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;

    self.chatRooms = [[NSMutableArray alloc] init];

    [[LocationHelper sharedLocationHelper] startLocationServices];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadChats];
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
                 [UIView animateWithDuration:1.0 animations:^{
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
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *chatroom = self.chatRooms[indexPath.row];
    //NSString *roomId = chatroom.objectId;
    //CreateMessageItem([PFUser currentUser], roomId, chatroom[PF_CHATROOMS_NAME]);
    
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

#pragma mark - Private Methods
- (void)loadChats {
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    //[query whereKey:@"centerPoint" nearGeoPoint:[[LocationHelper sharedLocationHelper] getLastGeoPoint] withinMiles:3.5];
    //[query whereKey:@"active" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (error == nil)
         {
             [self.chatRooms removeAllObjects];
             for (PFObject *object in objects)
             {
                 [self.chatRooms addObject:object];
             }
             //[ProgressHUD dismiss];
             [self.tableView reloadData];
         }
         else {
             //[ProgressHUD showError:@"Network error."];
         }
     }];

}
@end
