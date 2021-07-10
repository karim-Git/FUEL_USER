//
//  GoogleMapView.h
//  GoogleMapsSample
//
//  Created by Sandeep Kumar Rachha on 10/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "O1LocationManager.h"
#import "Fuelster-Swift.h"

extern  NSString * const GoogleMap_API_Key;

@protocol GoogleMapViewDelegate <NSObject>

@optional

- (BOOL)mapView:(GMSMapView *)mapView didTapMarkerOrder:(GMSMarker *)marker;



@end
@interface GoogleMapView : NSObject <GMSMapViewDelegate>
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic,strong) GMSMapView *mapView;
@property (nonatomic,strong) GMSMarker *myLocationMarker;
@property (nonnull, strong)NSString *myLocationAddress;
@property (nonnull, strong)id<GoogleMapViewDelegate> delegate;
@property (nonatomic,strong) O1LocationManager *locManager;
@property (nonatomic,strong) NSMutableArray *allMarkers;



+(nonnull GoogleMapView *)sharedInsatnceWithMapViewDelegate:(id)delegate1;
- (void)addMapViewWithFrame:(CGRect)frame superView:(nonnull UIView *)superView;
- (void)addMyLocationMarker;
- (void)addMarkers:(NSArray *)markers;
- (GMSMapView *)googleMapView;
- (void) removeAllMarkers;

NS_ASSUME_NONNULL_END
@end
