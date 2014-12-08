//
//  CreateChatViewController.m
//  Eclipse
//
//  Created by Mark Meyer on 12/7/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "CreateChatViewController.h"

#import "UIColor+Eclipse.h"

@interface CreateChatViewController ()
@property (strong, nonatomic) NSArray *EclipseColors;
@property (nonatomic) NSUInteger colorIndex;
@end

@implementation CreateChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"CREATE A CONVERSATION";
    
    self.EclipseColors = @[[UIColor eclipseDarkBlueColor], [UIColor eclipseYellowColor], [UIColor eclipseMagentaColor], [UIColor eclipseLightBlueColor], [UIColor eclipseRedColor]];
    self.colorIndex = 0;
}

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

- (IBAction)cameraTapped:(id)sender {
    //TODO: Get photo from library or camera
}

- (IBAction)refreshTapped:(id)sender {

    self.colorIndex++;
    
    self.titleTextView.backgroundColor = [self.EclipseColors objectAtIndex:self.colorIndex%[self.EclipseColors count]];
}

- (IBAction)postTapped:(id)sender {
    //TODO: Post and advance
}

- (IBAction)communityGuidelinesTapped:(id)sender {
    //TODO: Open webview to guidelines
}

- (IBAction)privacyTapped:(id)sender {
    //TODO: Open webview to privacy
}
@end
