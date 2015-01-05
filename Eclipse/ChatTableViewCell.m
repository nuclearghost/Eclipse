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
    self.timeLabel.text = [NSString stringWithFormat:@"%2.0fh:%2.0fm:%2.0ds", hours, minutes, (int)seconds % 60];
}

@end
