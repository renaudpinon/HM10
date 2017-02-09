//
//  UICellDevice.m
//  TestBTLE
//
//  Created by Reno on 11/06/2016.
//  Copyright © 2016 RPSOFT. All rights reserved.
//

#import "UICellDevice.h"

@implementation UICellDevice


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithDeviceName:(NSString*)deviceName
{
    self.DeviceName = (deviceName == nil) ? @"" : [deviceName copy];
    
    _lblDeviceName.text = self.DeviceName;
}

@end
