//
//  ShareManager.h
//  Eclipse
//
//  Created by Mark Meyer on 1/2/15.
//  Copyright (c) 2015 Mark Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

@property (strong, nonatomic) NSString *roomId;

+(id)sharedShareManager;

@end
