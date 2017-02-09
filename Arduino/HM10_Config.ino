#include <SoftwareSerial.h>

// Defines:
#define kBTPinRx        10
#define kBTPinTx        11

// Variables globales:
SoftwareSerial _btSerial = SoftwareSerial(kBTPinRx, kBTPinTx);

// Initialisation:
void setup()
{
    // Démarre la communication série avec l’ordinateur:
    Serial.begin(9600);
    while (!Serial) { ; /* attente interface dispo */ }
    
    // Démarre la communication série avec le HM-10:
    _btSerial.begin(9600);
    while (!_btSerial) { ; /* attente interface dispo */ }
}

// Boucle principale:
void loop()
{
    // Lecture des données provenant du module bluetooth:
    while (_btSerial.available() > 0)
    {
        Serial.print( (char)_btSerial.read() );
    }
    
    // Lecture des données envoyées depuis l'ordinateur:
    while (Serial.available() > 0)
    {
        _btSerial.write( Serial.read() );
    }
}
