//
//  ZGLLocationSource.h
//  GeoLogger
//
//  Created by Zsolt Kiraly on 11/1/13.
//  Copyright (c) 2013 Zsolt Kiraly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZGLLocationSource : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)startStandardUpdates;

@end
