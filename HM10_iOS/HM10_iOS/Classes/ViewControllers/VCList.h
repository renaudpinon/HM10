//
//  VCListe.h
//  HM10_iOS
//
//  Created by Renaud Pinon on 07/02/2017.
//

#import <UIKit/UIKit.h>
#import <CoreBlueTooth/CoreBlueTooth.h>

#import "UICellDevice.h"
#import "VCMain.h"


@interface VCList : UITableViewController <CBCentralManagerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* _tableDevices;
    
    CBCentralManager* _btManager;
    CBPeripheral* _peripheral;
    
    NSMutableArray* _arDevices;
}

@end
