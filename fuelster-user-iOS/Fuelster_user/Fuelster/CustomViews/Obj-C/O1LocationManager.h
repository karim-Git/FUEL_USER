//
//  O1LocationManager.h
//  Workspot
//
//  Created by Abhijeet Kumar on 10/31/12.
//  Copyright (c) 2012 O1 Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


/**
 * @brief
 * This is a Location Manager for Workspot
 *
 * This Class manages CLLocationManager and does reverse geocoding.
 */
@interface O1LocationManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedInstance;

- (CLAuthorizationStatus) authorizationStatus;
- (void) start;
- (void) stop;
- (void) invalidate;

@property (nonatomic, readonly) CLLocation *currentLocation;
@property (nonatomic, readonly) CLPlacemark *currentPlacemark;

@end


