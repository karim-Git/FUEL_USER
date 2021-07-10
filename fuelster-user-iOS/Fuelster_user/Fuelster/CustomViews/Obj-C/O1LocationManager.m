
//
//  O1LocationManager.m
//  Workspot
//
//  Created by Abhijeet Kumar on 10/31/12.
//  Copyright (c) 2012 O1 Works. All rights reserved.
//

@import CoreLocation;
#import "O1LocationManager.h"

@interface O1LocationManager()
@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLPlacemark *currentPlacemark;
@property (nonatomic, assign) BOOL geoRequestInProgress;

@end

@implementation O1LocationManager


+ (instancetype)sharedInstance
{
    static O1LocationManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[super allocWithZone:NULL] init];

    });
    return _sharedInstance;
}

-(id) init
{
    if ((self = [super init]) != nil)
    {
        _locationManager = [CLLocationManager new];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _currentLocation = _locationManager.location;
        _geoCoder = [CLGeocoder new];
        _locationManager.delegate = self;
        
        /*[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          [_locationManager stopMonitoringSignificantLocationChanges];
                                                      }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          [_locationManager startMonitoringSignificantLocationChanges];
                                                      }];*/

    }
    
    return self;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Location Updates

- (void) start
{
    if ([CLLocationManager locationServicesEnabled] == YES)
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
      
        if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            [_locationManager startUpdatingLocation];
            [_locationManager startMonitoringSignificantLocationChanges];
        }
        else if (status == kCLAuthorizationStatusNotDetermined)
        {
            if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
                [_locationManager startUpdatingLocation];
            }
            else
            {
                // on iOS7 this will trigger the access request dialog
                [_locationManager startUpdatingLocation];
            }
        }
    }
}

- (void) stop
{
    [_locationManager stopUpdatingLocation];
}

- (void) invalidate
{
    if ([self.currentLocation.timestamp compare:self.locationManager.location.timestamp] == NSOrderedAscending) {
        self.currentLocation = self.locationManager.location;
    } else {
        self.currentLocation = nil;
    }
    
    self.currentPlacemark = nil;
}

- (CLAuthorizationStatus) authorizationStatus
{
    return [CLLocationManager authorizationStatus];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations lastObject];
    
    if ([self.currentLocation.timestamp compare:self.locationManager.location.timestamp] == NSOrderedAscending) {
        self.currentLocation = self.locationManager.location;
    }

    /*
     * Lets geocode if we successfully find a location
     */
    if (!self.geoRequestInProgress)
    {
      //  //NSLog(@"Request for reverse geocode location\n");
        self.geoRequestInProgress = YES;
        [self.geoCoder reverseGeocodeLocation:self.currentLocation
                            completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             self.geoRequestInProgress = NO;
             if (error == nil) {
                 /*
                  * Most confident placemark is first object
                  */
                 self.currentPlacemark = [placemarks objectAtIndex:0];
                 NSString *address = [[self.currentPlacemark.addressDictionary valueForKey:@"FormattedAddressLines"]
                                      componentsJoinedByString:@", "];
                 //NSLog(@"Device is currently at %@\n", address);
             } else {
                // O1LOG_UTIL_WRN(@"Error %@\n", [error localizedDescription]);
             }
         }
         ];
    }
    
    /*
     * Right now, we don't need to continuously monitor location changes
     */
    [self stop];
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"Location was not found with error: %@\n", [error localizedDescription]);
    
    /*
     * Right now, we don't need to continuously monitor location changes
     */
    //[self stop];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Location authorization status: %@\n",
                   [self readableStringStatus:status]);
}

#pragma mark - Diagnostics

- (NSString *) readableStringStatus:(CLAuthorizationStatus)status
{
    NSString *reason = @"Unknown status";
    
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            reason = @"User has not yet made a choice";
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager startUpdatingLocation];

            break;
        case kCLAuthorizationStatusRestricted:
            reason = @"Application is not authorized to use location services (one possible reason could be parental controls)";
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager startUpdatingLocation];

            break;
        case kCLAuthorizationStatusDenied:
            reason = @"User has explicitly turned off system wide location services or specifically denied location access to application";
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorized:
            reason = @"User has authorized this application to use location services";
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager startUpdatingLocation];
            break;
        default:
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager startUpdatingLocation];
            break;
    }

    return reason;
}

@end