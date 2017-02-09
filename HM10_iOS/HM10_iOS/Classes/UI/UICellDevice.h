//
//  UICellDevice.h
//  TestBTLE
//
//  Created by Reno on 11/06/2016.
//  Copyright © 2016 RPSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICellDevice : UITableViewCell
{
    IBOutlet UILabel* _lblDeviceName;
}

@property (nonatomic, retain) NSString* DeviceName;

- (void)updateWithDeviceName:(NSString*)deviceName;

@end
