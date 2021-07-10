//
//  GoogleMapView.m
//  GoogleMapsSample
//
//  Created by Sandeep Kumar Rachha on 10/08/16.
//  Copyright © 2016 RBA. All rights reserved.
//

#import "GoogleMapView.h"

 NSString * const GoogleMap_API_Key = @"AIzaSyD1aspFdyfEQ0IeHm4utuCnav4KagybRiE";

@interface GoogleMapView ()

@property (nonatomic,strong) GMSGeocoder *geoCoder;
@property (nonatomic,strong) GMSCameraPosition *camera;
@property (nonatomic,strong) GMSMapView *mapview;
@property (nonatomic,strong) NSMutableArray *markers;
@property (nonnull,strong) GMSCircle *myLocationOverLay;

@end

@implementation GoogleMapView
@synthesize locManager, allMarkers;
static GoogleMapView *instance = nil;

+(nonnull GoogleMapView *)sharedInsatnceWithMapViewDelegate:(id)delegate1 {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        instance = [[GoogleMapView alloc] initWithDelegate:delegate1];
    });
    return instance;
}


- (id)initWithDelegate:(id)delegate1 {
    self = [super init];
    if (self) {
        //Setup proprties here
        self.allMarkers = [[NSMutableArray alloc] init];
        self.delegate = delegate1;
        self.locManager = [O1LocationManager sharedInstance];
        [self.locManager start];
        [self.locManager addObserver:self forKeyPath:@"currentLocation" options:NSKeyValueObservingOptionNew context:nil];

        [GMSServices provideAPIKey:GoogleMap_API_Key];
        self.mapView = [self setupMapView];
        self.mapView.delegate = self;
        self.mapView.myLocationEnabled = true;
        self.markers = [[NSMutableArray alloc] init];
        self.myLocationOverLay = [[GMSCircle alloc] init];

    }
    
    return self;
}


- (GMSMapView *)setupMapView {
   self.camera = [GMSCameraPosition cameraWithLatitude:self.mapView.myLocation.coordinate.latitude
                                                            longitude:self.mapView.myLocation.coordinate.longitude
                                                                 zoom:13];
    self.mapview = [GMSMapView mapWithFrame:CGRectZero camera:self.camera];
   // self.mapview.myLocationEnabled = YES;

    // Creates a marker in the center of the map.
    self.myLocationMarker = [[GMSMarker alloc] init];
    [self addObserver:self forKeyPath:@"myLocationAddress" options:NSKeyValueObservingOptionNew context:nil];
    //self.myLocationMarker.position = self.mapView.myLocation.coordinate;
    
    [self fullAddressForPosition:self.myLocationMarker.position withMarker:self.myLocationMarker];
    self.myLocationMarker.map = self.mapview;
    self.myLocationMarker.icon = [UIImage imageNamed:@"LocationMarker"];
    self.myLocationMarker.draggable = YES;
    self.myLocationMarker.tracksInfoWindowChanges = YES;
    self.myLocationMarker.infoWindowAnchor = CGPointMake(0.5, 0.2);
    return  self.mapview;
}

- (GMSMapView *)googleMapView {
    
    return self.mapView;
}

- (void)addMyLocationMarker {
    
    self.myLocationMarker = [[GMSMarker alloc] init];
    [self.myLocationMarker addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    self.myLocationMarker.position = self.mapView.myLocation.coordinate;
    
    [self fullAddressForPosition:self.myLocationMarker.position withMarker:self.myLocationMarker];
    self.myLocationMarker.map = self.mapview;
    self.myLocationMarker.draggable = YES;
    //self.myLocationMarker.tracksInfoWindowChanges = YES;
    self.myLocationMarker.infoWindowAnchor = CGPointMake(0.5, 0.2);

}

- (void)addMarkers:(NSArray *)markers {
    self.markers = markers;
   
    for (NSDictionary *markerInfo in self.markers) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.map = self.mapview;
        marker.draggable = YES;
        marker.tracksInfoWindowChanges = YES;
        marker.infoWindowAnchor = CGPointMake(0.5, 0.2);
        [self fullAddressForPosition:marker.position withMarker:marker];
    }
}



- (void) removeAllMarkers
{
    for (GMSMarker *marker in self.allMarkers) {
        marker.map = nil;
    }
}
- (void)addMapViewWithFrame:(CGRect)frame superView:(UIView *)superView {
    self.mapView.frame = frame;
    [superView addSubview:self.mapView];
}


- (void)addMyLocationCircleOverlay {
    
    self.myLocationOverLay.position = self.myLocationMarker.position;
    self.myLocationOverLay.radius = 1000;
    self.myLocationOverLay.fillColor = [UIColor colorWithRed:0.25 green:0 blue:0 alpha:0.05];
    self.myLocationOverLay.strokeColor = [UIColor redColor];
    self.myLocationOverLay.strokeWidth = 5;
    self.myLocationOverLay.map = self.mapView;
}



// TODO:
- (void)setMarkerPosition:(CLLocationCoordinate2D) position {
    
}


-(void)setCustomIconWithImageName:(NSString *) imageName marker:(GMSMarker *)marker {
    marker.icon = [UIImage imageNamed:imageName];
}

- (void)fullAddressForPosition:(CLLocationCoordinate2D)position withMarker:(GMSMarker * _Nullable)marker {
    if (!self.geoCoder)
        self.geoCoder = [GMSGeocoder geocoder];
    
    [self.geoCoder reverseGeocodeCoordinate:marker.position completionHandler:^(GMSReverseGeocodeResponse *response , NSError * error) {
        
        //NSLog(@"first result = %@",response.firstResult);
        //NSLog(@"all result = %@",response.results);
        __block NSString *address = @"";
        [response.firstResult.lines enumerateObjectsUsingBlock:^(NSString * str, NSUInteger idx, BOOL * _Nonnull stop) {
            
            address = [address stringByAppendingString:str];
        }];
        if (marker) {
           // marker.title = address;
            self.myLocationAddress = address;
            self.myLocationMarker.position = position;
           // marker.snippet = response.firstResult.country;
        }
    }];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
   
    if ([keyPath isEqualToString:@"currentLocation"]) {
        CLLocation *loc = (CLLocation *) change[@"new"];
        self.myLocationMarker.position = loc.coordinate;
        [self.mapView moveCamera:[GMSCameraUpdate setTarget:loc.coordinate]];
        [self fullAddressForPosition:loc.coordinate withMarker:self.myLocationMarker];
       // [self addMyLocationCircleOverlay];
    }
    
    if ([keyPath isEqualToString:@"title"]) {
        GMSMarker *marker = (GMSMarker *)object;
        
        if (marker == self.myLocationMarker) {
            [self.locManager stop];
            self.myLocationAddress = self.myLocationMarker.title;
            [self.mapView moveCamera:[GMSCameraUpdate setTarget:self.myLocationMarker.position]];
          //  [self addMyLocationCircleOverlay];
        }

    }

}


#pragma mark Google MapView Delagate Methods

/**
 * Called before the camera on the map changes, either due to a gesture,
 * animation (e.g., by a user tapping on the "My Location" button) or by being
 * updated explicitly via the camera or a zero-length animation on layer.
 *
 * @param gesture If YES, this is occuring due to a user gesture.
 */
- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture {
    
}

/**
 * Called repeatedly during any animations or gestures on the map (or once, if
 * the camera is explicitly set). This may not be called for all intermediate
 * camera positions. It is always called for the final position of an animation
 * or gesture.
 */
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position{
    
}

/**
 * Called when the map becomes idle, after any outstanding gestures or
 * animations have completed (or after the camera has been explicitly set).
 */
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position{
    
}

/**
 * Called after a tap gesture at a particular coordinate, but only if a marker
 * was not tapped.  This is called before deselecting any currently selected
 * marker (the implicit action for tapping on the map).
 */
- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
}

/**
 * Called after a long-press gesture at a particular coordinate.
 *
 * @param mapView The map view that was pressed.
 * @param coordinate The location that was pressed.
 */
- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
}

/**
 * Called after a marker has been tapped.
 *
 * @param mapView The map view that was pressed.
 * @param marker The marker that was pressed.
 * @return YES if this delegate handled the tap event, which prevents the map
 *         from performing its default selection behavior, and NO if the map
 *         should continue with its default selection behavior.
 */
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    
    if (marker == self.myLocationMarker)
    {
        return YES;
    }
    [self.delegate mapView:mapView didTapMarkerOrder:marker];
    return YES;
}

/**
 * Called after a marker's info window has been tapped.
 */
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker{
    
}

/**
 * Called after a marker's info window has been long pressed.
 */
- (void)mapView:(GMSMapView *)mapView didLongPressInfoWindowOfMarker:(GMSMarker *)marker{
    
}

/**
 * Called after an overlay has been tapped.
 * This method is not called for taps on markers.
 *
 * @param mapView The map view that was pressed.
 * @param overlay The overlay that was pressed.
 */
- (void)mapView:(GMSMapView *)mapView didTapOverlay:(GMSOverlay *)overlay{
    
}

/**
 * Called when a marker is about to become selected, and provides an optional
 * custom info window to use for that marker if this method returns a UIView.
 * If you change this view after this method is called, those changes will not
 * necessarily be reflected in the rendered version.
 *
 * The returned UIView must not have bounds greater than 500 points on either
 * dimension.  As there is only one info window shown at any time, the returned
 * view may be reused between other info windows.
 *
 * Removing the marker from the map or changing the map's selected marker during
 * this call results in undefined behavior.
 *
 * @return The custom info window for the specified marker, or nil for default
 */
- (UIView *GMS_NULLABLE_PTR)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    
    return nil;
}

/**
 * Called when mapView:markerInfoWindow: returns nil. If this method returns a
 * view, it will be placed within the default info window frame. If this method
 * returns nil, then the default rendering will be used instead.
 *
 * @param mapView The map view that was pressed.
 * @param marker The marker that was pressed.
 * @return The custom view to display as contents in the info window, or nil to
 * use the default content rendering instead
 */

//- (UIView *GMS_NULLABLE_PTR)mapView:(GMSMapView *)mapView markerInfoContents:(GMSMarker *)marker {
//    
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
//    [v setBackgroundColor:[UIColor redColor]];
//    return nil;
//}

/**
 * Called when the marker's info window is closed.
 */
- (void)mapView:(GMSMapView *)mapView didCloseInfoWindowOfMarker:(GMSMarker *)marker{
    
}

/**
 * Called when dragging has been initiated on a marker.
 */
- (void)mapView:(GMSMapView *)mapView didBeginDraggingMarker:(GMSMarker *)marker{
    
}

/**
 * Called after dragging of a marker ended.
 */
- (void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker {
    
    [self fullAddressForPosition:marker.position withMarker:marker];
    self.myLocationOverLay.map = nil;
}

/**
 * Called while a marker is dragged.
 */
- (void)mapView:(GMSMapView *)mapView didDragMarker:(GMSMarker *)marker{
    
}

/**
 * Called when the My Location button is tapped.
 *
 * @return YES if the listener has consumed the event (i.e., the default behavior should not occur),
 *         NO otherwise (i.e., the default behavior should occur). The default behavior is for the
 *         camera to move such that it is centered on the user location.
 */
- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView{
   
    self.myLocationMarker.position = self.mapView.myLocation.coordinate;
    [self.mapView moveCamera:[GMSCameraUpdate setTarget:self.myLocationMarker.position]];
    return YES;
}

/**
 * Called when tiles have just been requested or labels have just started rendering.
 */
- (void)mapViewDidStartTileRendering:(GMSMapView *)mapView{
    
}

/**
 * Called when all tiles have been loaded (or failed permanently) and labels have been rendered.
 */
- (void)mapViewDidFinishTileRendering:(GMSMapView *)mapView{
    
}

/**
 * Called when map is stable (tiles loaded, labels rendered, camera idle) and overlay objects have
 * been rendered.
 */
- (void)mapViewSnapshotReady:(GMSMapView *)mapView{
    
}


- (void)dealloc{
    [self.myLocationMarker removeObserver:self forKeyPath:@"title"];
    //self.allMarkers = nil;
}

@end
