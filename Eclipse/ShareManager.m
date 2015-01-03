//
//  ShareManager.m
//  Eclipse
//
//  Created by Mark Meyer on 1/2/15.
//  Copyright (c) 2015 Mark Meyer. All rights reserved.
//

#import "ShareManager.h"

@implementation ShareManager

+ (id)sharedShareManager {
    static ShareManager *sharedShareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedShareManager = [[self alloc] init];
    });
    return sharedShareManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
