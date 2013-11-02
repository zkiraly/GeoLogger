//
//  ZGLListCell.h
//  GeoLogger
//
//  Created by Zsolt Kiraly on 11/2/13.
//  Copyright (c) 2013 Zsolt Kiraly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZGLListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *latitude;
@property (weak, nonatomic) IBOutlet UILabel *longitude;

@end
