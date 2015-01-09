//
//  MainSlideViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 12/8/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "MainSlideViewController.h"

@interface MainSlideViewController ()

@end

@implementation MainSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    switch (indexPath.row) {
        case 1:
            identifier = @"firstRow";
            break;
        case 2:
            identifier = @"profileRow";
            break;
        case 3:
            identifier = @"aboutRowSegue";
            break;
    }
    
    return identifier;
}

- (void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame = CGRectMake(0, 0, 30, 30);
    button.frame = frame;
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    
}

- (NSIndexPath *)initialIndexPathForLeftMenu {
    return [NSIndexPath indexPathForItem:1 inSection:0];
}

- (CGFloat) panGestureWarkingAreaPercent {
    return 15.0;
}

- (void) configureSlideLayer:(CALayer *)layer
{
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 1;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowRadius = 5;
    layer.masksToBounds = NO;
    layer.shadowPath =[UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
}

@end
