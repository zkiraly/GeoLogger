//
//  ZGLLocationSource.m
//  GeoLogger
//
//  Created by Zsolt Kiraly on 11/1/13.
//  Copyright (c) 2013 Zsolt Kiraly. All rights reserved.
//

#import "ZGLLocationSource.h"

@implementation ZGLLocationSource

- (id)init {
    self = [super init];
    if (self) {
        // load stored data from file
        _locations = [[NSMutableArray alloc] initWithCapacity:100];
    }
    
    return self;
}

- (void)saveData {
    // save or re-save the location array
}

- (void)startStandardUpdates
{
    NSLog(@"LocationSource: startStandardUpdates");
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationManager)
        _locationManager = [[CLLocationManager alloc] init];
    
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    // Set a movement threshold for new events.
    _locationManager.distanceFilter = 200; // meters
    
    [_locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    NSLog(@"Received locations from locationManager: %@", locations);
    // add them to the locations array
    
    [_locations addObjectsFromArray:locations];
    
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}
#if 0
- (NSArray *)locations {
    NSLog(@"View is asking for the locations");
    // force delivery of a recent location
#if 0
    [_locationManager stopUpdatingLocation];
    
    CLLocation *loc = [_locationManager location];
    if (loc) {
        [_locations addObject:loc];
    }
    
    [_locationManager startUpdatingLocation];
#endif
    
    return _locations;
}
#endif



@end
