//
//  LocationHelper.h
//  Eclipse
//
//  Created by Mark Meyer on 11/3/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
@import CoreLocation;

@interface LocationHelper : NSObject <CLLocationManagerDelegate>


+ (id)sharedLocationHelper;

- (void)startLocationServices;
- (CLLocation *)getLastLocation;
- (PFGeoPoint *)getLastGeoPoint;

@end
