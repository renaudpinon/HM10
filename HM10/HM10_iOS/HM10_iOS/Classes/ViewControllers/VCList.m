//
//  VCListe.m
//  HM10_iOS
//
//  Created by Renaud Pinon on 07/02/2017.
//

#import "VCList.h"

@implementation VCList

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialise le tableau des matériels BT:
    _arDevices = [NSMutableArray array];
    
    // Initialise le BT manager:
    [self configureBTCentralManager];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_btManager != nil)
    {
        // Assigne le contrôleur de liste en tant que delegate du BT manager.
        // Cela déclenche les méthodes se conformant au protocole CBCentralManagerDelegate:
        _btManager.delegate = self;
        
        if (_peripheral != nil)
        {
            // Au cas où une connexion serait en cours, on l'annule:
            [_btManager cancelPeripheralConnection:_peripheral];
            
            // On réinitialise _peripheral à la valeur nulle:
            _peripheral = nil;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions Interface Builder

/**
 * Rafraichit la liste des modules.
 *
 * @param sender Expéditeur de l'action.
 */
- (IBAction)RefreshDevices:(id)sender
{
    [self refreshDevices];
}


#pragma mark - Methodes privées

/**
 * Crée le BT Manager.
 */
- (void)configureBTCentralManager
{
    // Create BT manager:
    _btManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:nil];
}


/**
 * Rafraichit la liste des modules.
 */
- (void)refreshDevices
{
    [_arDevices removeAllObjects];
    
    NSArray* arUUID = @[[CBUUID UUIDWithString:@"FFE0"]];
    
    [_btManager stopScan];
    
    // Start to scan for peripherals corresponding to HM-10/11 module (UUID = "FFE0"):
    [_btManager scanForPeripheralsWithServices:arUUID options:nil];
    
    // Add already detected peripherals to the list:
    NSArray* peripherals = [_btManager retrieveConnectedPeripheralsWithServices:arUUID];
    for (CBPeripheral* peripheral in peripherals)
    {
        [_arDevices addObject:peripheral];
    }
    
    [_tableDevices reloadData];
}


#pragma mark - Méthodes déléguées BT Manager

/**
 * Appelé lorsqu'un périphérique a été découvert.
 *
 * @param central BT Manager.
 * @param peripheral Périphérique découvert.
 * @param advertisementData Données de publication.
 * @param RSSI Identifiant.
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (peripheral != nil && [_arDevices containsObject:peripheral] == NO)
    {
        [_arDevices addObject:peripheral];
        [_tableDevices reloadData];
    }
}

/**
 * Appelé quand l'état du BT Manager a changé (par ex. l'utilisateur désactive le BT sur son appareil)
 *
 * @param central BT Manager.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (_btManager.state == CBCentralManagerStatePoweredOn)
    {
        [self refreshDevices];
    }
}


#pragma mark - Methodes déléguées Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (_arDevices == nil) ? 0 : _arDevices.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"cellDevice";
    UICellDevice* cell = nil;
    
    if ([tableView respondsToSelector:@selector(dequeueReusableCellWithIdentifier:forIndexPath:)])
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    else
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UICellDevice alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (_arDevices.count > indexPath.row)
    {
        CBPeripheral* peripheral = [_arDevices objectAtIndex:indexPath.row];
        if (peripheral != nil)
        {
            [cell updateWithDeviceName:peripheral.name];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _arDevices.count)
    {
        CBPeripheral* peripheral = [_arDevices objectAtIndex:indexPath.row];
        if (peripheral != nil)
        {
            _peripheral = peripheral;
            
            // On change d'écran pour afficher l'écran principal:
            [self performSegueWithIdentifier:@"segueMain" sender:self];
        }
    }
}


#pragma mark - Logique de navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueMain"])
    {
        VCMain* vcMain = (VCMain*)segue.destinationViewController;
        if (vcMain != nil)
        {
            vcMain.BTManager = _btManager;
            vcMain.Peripheral = _peripheral;            
        }
    }
}


@end
