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
#import "LocationHelper.h"

@interface ChatRoomTableViewController ()

@property (strong, nonatomic) NSMutableArray *chatRooms;

@end

@implementation ChatRoomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;

    self.chatRooms = [[NSMutableArray alloc] init];

    [[LocationHelper sharedLocationHelper] startLocationServices];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *chatRoom = [self.chatRooms objectAtIndex:indexPath.row];
    
    cell.textLabel.text = chatRoom[@"Name"];
    PFGeoPoint *point = chatRoom[@"centerPoint"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f, %f", point.latitude, point.longitude];
    
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"roomSegue"]) {
        ChatViewController *cvc = (ChatViewController *)[segue destinationViewController];
        cvc.room = (PFObject *)sender;
    }
}


#pragma mark - UIBarButton Action

- (IBAction)addTapped:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter a topic for your rift" message:nil delegate:self
                                          cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text isEqualToString:@""] == NO)
        {
            PFObject *chatRoom = [PFObject objectWithClassName:@"ChatRoom"];
            chatRoom[@"Name"] = textField.text;
            chatRoom[@"creator"] = [PFUser currentUser];
            chatRoom[@"centerPoint"] = [[LocationHelper sharedLocationHelper] getLastGeoPoint];
            [chatRoom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                 if (error == nil)
                 {
                     [self loadChats];
                 }
                 else {
                     //[ProgressHUD showError:@"Network error."];
                 }
             }];
        }
    }
}

#pragma mark - Private Methods
- (void)loadChats {
    PFQuery *query = [PFQuery queryWithClassName:@"ChatRoom"];
    [query whereKey:@"centerPoint" nearGeoPoint:[[LocationHelper sharedLocationHelper] getLastGeoPoint] withinMiles:3.5];
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
             //[ProgressHUD dismiss];
             [self.tableView reloadData];
         }
         else {
             //[ProgressHUD showError:@"Network error."];
         }
     }];

}
@end
