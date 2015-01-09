//
//  UIColor+Eclipse.h
//  Eclipse
//
//  Created by Mark Meyer on 12/7/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UIColor (Eclipse)
+ (UIColor*)eclipseMagentaColor;
+ (UIColor*)eclipseRedColor;
+ (UIColor*)eclipseYellowColor;
+ (UIColor*)eclipseLightBlueColor;
+ (UIColor*)eclipseDarkBlueColor;
+ (UIColor*)eclipseGrayColor;
+ (UIColor*)eclipseMedGrayColor;
+ (UIColor*)eclipseLightGrayColor;
@end
