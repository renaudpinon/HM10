//
//  VCMain.h
//  HM10_iOS
//
//  Created by Renaud Pinon on 07/02/2017.
//

#import <UIKit/UIKit.h>
#import <CoreBlueTooth/CoreBlueTooth.h>

@interface VCMain : UIViewController <CBCentralManagerDelegate, CBPeripheralDelegate, UITextFieldDelegate>
{
    IBOutlet UITextField* _txtMessage;
    IBOutlet UIButton* _bttnSend;
    IBOutlet UITextView* _txtLog;
    IBOutlet UISegmentedControl* _segModuleType;
    
    CBCharacteristic* _btCharacteristic;
}

@property (nonatomic, retain) CBPeripheral* Peripheral;
@property (nonatomic, retain) CBCentralManager* BTManager;


@end
