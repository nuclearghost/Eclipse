//
//  LeftMenuViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 12/8/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "LeftMenuViewController.h"

@interface LeftMenuViewController ()

@property (strong, nonatomic) UITableView *myTableView;

@end

@implementation LeftMenuViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && ![UIApplication sharedApplication].isStatusBarHidden)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // The device is an iPhone or iPod touch.
        [self setFixedStatusBar];
    }
}

- (void)setFixedStatusBar
{
    self.myTableView = self.tableView;
    
    self.view = [[UIView alloc] initWithFrame:self.view.bounds];
    self.view.backgroundColor = self.myTableView.backgroundColor;
    [self.view addSubview:self.myTableView];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(self.view.frame.size.width,self.view.frame.size.height), 20)];
    statusBarView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:statusBarView];
}

@end
