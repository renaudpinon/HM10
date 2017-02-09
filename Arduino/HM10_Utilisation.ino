#include <SoftwareSerial.h>

// Defines:
#define kBTPinRx        10
#define kBTPinTx        11

// Variables globales:
SoftwareSerial _btSerial(kBTPinRx, kBTPinTx);
String _btBuffer = "";

// Initialisation:
void setup()
{
    // put your setup code here, to run once:
    _btSerial.begin(9600);
    while (!_btSerial) { ; /* wait for serial port to connect */ }

    Serial.begin(9600);
    while (!Serial) { ; /* wait for serial port to connect */ }
}

// Fonction principale:
void loop()
{
    // Réception des données envoyées du smartphone au module bluetooth:
    while (_btSerial.available() > 0)
    {
        char letter = (char)_btSerial.read();
        if (letter != '\r' && letter != '\n')
        {
            _btBuffer += String(letter);
        }
        else if (letter == '\n')
        {
            // Fin de commande (\n = séparateur de commmandes):
            Serial.println(_btBuffer);  // pour le debug.
            
            // TODO: on peut ici interpréter les données et faire agir l'Arduino en
            // conséquence ou afficher la chaîne reçue sur un écran LCD par exemple.
            
            _btBuffer = ""; // réinitialisation du buffer.
            
            _btSerial.println("Bien reçu !");  // accusé de réception.
        }
    }
}
