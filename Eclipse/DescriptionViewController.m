//
//  DescriptionViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 1/6/15.
//  Copyright (c) 2015 Mark Meyer. All rights reserved.
//

#import "DescriptionViewController.h"

@interface DescriptionViewController ()

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueTapped:(id)sender {
    [self performSegueWithIdentifier:@"descriptionToLocationSegue" sender:nil];
}
@end
