//
//  ZGLListViewController.m
//  GeoLogger
//
//  Created by Zsolt Kiraly on 11/2/13.
//  Copyright (c) 2013 Zsolt Kiraly. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ZGLListViewController.h"
#import "ZGLLocationSource.h"
#import "ZGLListCell.h"

@interface ZGLListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic)ZGLLocationSource *locationSource;
@end

@implementation ZGLListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _locationSource = [ZGLLocationSource sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _locationSource.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    ZGLListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = (ZGLListCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:MyIdentifier];
    }
    
    CLLocation *loc = _locationSource.locations[indexPath.row];
    
    NSLog(@"Filling the table with location %@", loc);

    cell.timestamp.text = [NSString stringWithFormat:@"%@", loc.timestamp];
    cell.latitude.text = [NSString stringWithFormat:@"%fN", loc.coordinate.latitude];
    cell.longitude.text = [NSString stringWithFormat:@"%fE", loc.coordinate.longitude];
    
    
    return cell;
}

@end
