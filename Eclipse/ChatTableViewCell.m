//
//  ChatTableViewCell.m
//  Eclipse
//
//  Created by Mark Meyer on 12/7/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTimestamp {
    NSTimeInterval seconds = [self.expiration timeIntervalSinceDate:[NSDate date]];
    double hours = floor(seconds/3600);
    double minutes = floor(((int)seconds % 3600)/60);
    self.timeLabel.text = [NSString stringWithFormat:@"%02.0fh:%02.0fm:%02ds", hours, minutes, (int)seconds % 60];
}

@end
