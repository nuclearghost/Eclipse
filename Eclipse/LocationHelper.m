//
//  LocationHelper.m
//  Eclipse
//
//  Created by Mark Meyer on 11/3/14.
//  Copyright (c) 2014 Mark Meyer. All rights reserved.
//

#import "LocationHelper.h"

@interface LocationHelper()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *lastLocation;

@end

@implementation LocationHelper

+ (id)sharedLocationHelper {
    static LocationHelper *sharedLocationHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocationHelper = [[self alloc] init];
    });
    return sharedLocationHelper;
}

- (id)init {
    if (self = [super init]) {
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        if (authStatus != kCLAuthorizationStatusDenied &&
            authStatus != kCLAuthorizationStatusRestricted) {
            
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    //self.lastLocation = [locations lastObject];
    NSLog(@"Received location: %@", self.lastLocation);
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [manager startMonitoringSignificantLocationChanges];
    }

}

- (void)startLocationServices {
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusDenied ||
        authStatus == kCLAuthorizationStatusRestricted) {
        //do nothing? Return something negative. A promise would help here
    } else if (authStatus == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
}

- (CLLocation *)getLastLocation {
    return self.locationManager.location;
}

- (PFGeoPoint *)getLastGeoPoint {
    return [PFGeoPoint geoPointWithLocation:self.locationManager.location];
}
@end
