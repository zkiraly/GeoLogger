//
//  ZGLViewController.m
//  GeoLogger
//
//  Created by Zsolt Kiraly on 11/1/13.
//  Copyright (c) 2013 Zsolt Kiraly. All rights reserved.
//

#import "ZGLViewController.h"
#import "ZGLLocationSource.h"

@interface ZGLViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, strong) ZGLLocationSource *locationSource;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@end

@implementation ZGLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _locationSource = [ZGLLocationSource sharedInstance];
    
    if (_locationSource) {
        _locationSource.locationManager = _locationManager;
        [self startStandardUpdates];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    // set up map
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startStandardUpdates
{
    NSLog(@"LocationSource: startStandardUpdates");
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.activityType = CLActivityTypeFitness;
    _locationManager.pausesLocationUpdatesAutomatically = YES;
    
    _locationManager.delegate = self;
    //_locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // Set a movement threshold for new events.
    _locationManager.distanceFilter = 100; // meters
    
    [_locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    [_locationSource locationManager:manager didUpdateLocations:locations];
    
    [self updateMap];
}

- (void)updateMap {
    // TODO: clear map of locations
    [_mapView removeOverlays:_mapView.overlays];
    
    // add polygon of path
    
    long coordsLen = _locationSource.locations.count;
    
    CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * coordsLen);
    for (int i=0; i < coordsLen; i++)
    {
        CLLocationCoordinate2D coordObj = ((CLLocation *)_locationSource.locations[i]).coordinate;
        coords[i] = coordObj;
    }
    MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:coordsLen];
    free(coords);
    
    [_mapView addOverlay:polyline level:MKOverlayLevelAboveRoads];
    
    
    
    MKCoordinateRegion region;
    if (coordsLen) {
        
        CLLocationCoordinate2D regionCoord = ((CLLocation *)_locationSource.locations.lastObject).coordinate;
        
        NSLog(@"Trying to ser region: %f N %f E", regionCoord.latitude, regionCoord.longitude);
        
        region = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(regionCoord, 2000,2000)];
        NSLog(@"Centering map on %@", _locationSource.locations.lastObject);
    } else {
        CLLocationCoordinate2D dLand = CLLocationCoordinate2DMake(33.8090, -117.9190);
        region = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(dLand, 2000,2000)];
    }
    [_mapView setRegion:region animated:YES];
    
    NSLog(@"Set map region to %f N, %f E, spanLat: %f spanLong: %f", _mapView.region.center.latitude, _mapView.region.center.longitude, _mapView.region.span.latitudeDelta, _mapView.region.span.longitudeDelta);
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;
    renderer.strokeColor = [UIColor blueColor];
    
    return renderer;
}

- (IBAction)updateLocation:(id)sender {
    NSLog(@"user wants updated location");
    
    [_locationManager stopUpdatingLocation];
    [_locationManager startUpdatingLocation];
}

@end
