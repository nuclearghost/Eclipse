//
//  NotificationAuthViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 1/6/15.
//  Copyright (c) 2015 Mark Meyer. All rights reserved.
//

#import "NotificationAuthViewController.h"

@interface NotificationAuthViewController ()

@end

@implementation NotificationAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapped:(id)sender {
    
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // Register for Push Notitications, if running iOS 8
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        // Register for Push Notifications before iOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
    [self performSegueWithIdentifier:@"locationToBetaSegue" sender:nil];
}

- (IBAction)laterTapped:(id)sender {
    [self performSegueWithIdentifier:@"locationToBetaSegue" sender:nil];
}
@end
