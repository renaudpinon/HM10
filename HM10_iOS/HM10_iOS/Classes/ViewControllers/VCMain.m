//
//  VCMain.m
//  HM10_iOS
//
//  Created by Renaud Pinon on 07/02/2017.
//

#import "VCMain.h"

@implementation VCMain

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.BTManager != nil)
    {
        self.BTManager.delegate = self;
        
        if (self.Peripheral != nil)
        {
            [self.BTManager connectPeripheral:self.Peripheral options:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions Interface Builder

- (IBAction)SendMessage:(id)sender
{
    [self sendBT:_txtMessage.text];
}


#pragma mark - Méthodes privées

/**
 * Envoie le message au module BT:
 *
 * @param message Chaine de caractères à envoyer au module BT.
 */
- (void)sendBT:(NSString*)message
{
    if (message != nil && [message isEqualToString:@""] == NO)
    {
        message = [message stringByAppendingString:@"\n"];  // Séparateur de commandes.
        
        // Transformation en octets:
        NSData* data = [message dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data != nil && data.length > 0)
        {
            // Ecriture des données vers le BT:
            [self.Peripheral writeValue:data forCharacteristic:_btCharacteristic type: CBCharacteristicWriteWithoutResponse];
            
            // Reset de la zone de texte:
            _txtMessage.text = @"";
            _bttnSend.enabled = NO;
        }
    }
}


#pragma mark - Methodes déléguées BT Manager

/**
 * Un périphérique a été connecté:
 *
 * @param central BT Manager.
 * @param peripheral Périphérique connecté.
 */
- (void)centralManager:(CBCentralManager*)central didConnectPeripheral:(CBPeripheral*)peripheral
{
    peripheral.delegate = self;
    
    self.navigationItem.title = peripheral.name;
     
    [peripheral discoverServices:@[ [CBUUID UUIDWithString:@"FFE0"] ]];
}

/**
 * Appelé quand l'état du BT Manager a changé (par ex. l'utilisateur désactive le BT sur son appareil)
 *
 * @param central BT Manager.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager*)central
{
    if (central.state != CBCentralManagerStatePoweredOn)
    {
        // on revient à la liste:
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/**
 * Appelé lorsqu'il y a une erreur de connexion à un périphérique.
 *
 * @param central BT Manager.
 * @param peripheral Périphérique sur lequel l'erreur se produit.
 * @param error Erreur.
 */
- (void)centralManager:(CBCentralManager*)central didFailToConnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    NSLog(@"Echec de connexion !");
}

/**
 * Un périphérique a été déconnecté
 *
 * @param central BT Manager.
 * @param peripheral Périphérique déconnecté.
 * @param error Erreur rencontrée.
 */
- (void)centralManager:(CBCentralManager*)central didDisconnectPeripheral:(CBPeripheral*)peripheral error:(NSError*)error
{
    if (peripheral == self.Peripheral)
    {
        self.Peripheral = nil;
        
        // Retour à l'écran principal s'il s'agit de notre périphérique:
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


#pragma mark - Methodes déléguées BT Peripheral

/**
 * Un service a été découvert sur un périphérique.
 *
 * @param peripheral Périphérique sur lequel le service a été trouvé.
 * @param error Erreur rencontrée.
 */
- (void)peripheral:(CBPeripheral*)peripheral didDiscoverServices:(NSError*)error
{
    for (CBService* service in peripheral.services)
    {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString: @"FFE1"]] forService: service];
    }
}

// :

/**
 * Une caractéristique a été découverte sur un périphérique.
 *
 * @param peripheral Périphérique sur lequel la caractéristique a été découverte.
 * @param service Service découvert.
 * @param error Erreur rencontrée.
 */
- (void)peripheral:(CBPeripheral*)peripheral didDiscoverCharacteristicsForService:(CBService*)service error:(NSError*)error
{
    // Note: il n'y a qu'une caractéristique, mais pour le fun
    // on les parcourt toutes quand même:
    for (CBCharacteristic* characteristic in service.characteristics)
    {
        // On sauvegarde la caractéristique pour la réutiliser lors de l'écriture:
        _btCharacteristic = characteristic;
        
        // Optionnel: permet de lire les données envoyées par le module BT:
        [peripheral setNotifyValue:true forCharacteristic:characteristic];
    }
}

// :

/**
 * Des données ont été reçues de la part d'un périphérique.
 *
 * @param peripheral Périphérique ayant reçu les données.
 * @param characteristic Caractéristique à laquelle appartiennent les données reçues.
 * @param error Erreur rencontrée.
 */
- (void)peripheral:(CBPeripheral*)peripheral didUpdateValueForCharacteristic:(CBCharacteristic*)characteristic error:(NSError*)error
{
    // Lecture de données provenant du module BT:
    if (characteristic == _btCharacteristic && characteristic.value != nil && characteristic.value.length > 0)
    {
        NSString* strData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        
        // Ajout du texte dans le journal:
        _txtLog.text = [_txtLog.text stringByAppendingString:strData];
    }
}


#pragma mark - Methodes déléguées UITextField

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    // Active ou non le bouton envoyer suivant si le textfield contient des caractères ou est vide:
    NSString* str = [_txtMessage.text stringByReplacingCharactersInRange:range withString:string];
    _bttnSend.enabled = ([str isEqualToString:@""] == NO);
    
    return YES;
}

@end
