# RuuvitagRestGateway
RuuvitagRestGateway is flask-restful based service that listens for ruuvitag BLE broadcasts and hosts REST Api.


# Requirements
* Running host needs Bluetooth. Tested and working on Raspberry Pi 4.
* [Ruuvitag(s)](https://ruuvi.com/) within Bluetooth range of running host.
* Modules: bluetooth, bluez, blueman, bluez-hcidump, pip3, ruuvitag-sensor, flask-restful, flask_cors, python-bluez


# Installation
Clone repository with your preferred way.<br>
Run inside RuuvitagRestGateway directory `sudo install.sh`. This will install required depencies and create service.<br>
Verify that the service is running `sudo service ruuvitagrestgateway status`<br>


# Usage
Api has two resources

Resource | Request | Reponse
------------ | ------------- | -------------
All Ruuvitags | curl http://**ip**:**port**/ | { "ruuvitags": [ { ruuvitag1 data }, { ruuvitag2 data },.. ] }
Spesific Ruuvitag | curl http://**ip**:**port**/ruuvitag/**ruuvitag mac** | { "ruuvitags": [ { ruuvitag data } ] }
Filtering Ruuvitags | curl http://**ip**:**port**/?filter=**mac**&filter=**mac2** | { "ruuvitags": [ { ruuvitag1 data }, { ruuvitag2 data } ] }

ruuvitag data example:

    {
        "data_format": 5,
        "humidity": 23.42,
        "temperature": 21.42,
        "pressure": 1003.67,
        "acceleration": 1001.3830435952069,
        "acceleration_x": -8,
        "acceleration_y": -52,
        "acceleration_z": 1000,
        "tx_power": 4,
        "battery": 2995,
        "movement_counter": 252,
        "measurement_sequence_number": 45328,
        "mac": "001122334455",
        "broadcasted": "2021-04-12T11:44:30.470027+03:00"
    }

\* Ruuvitags data depends on firmware and setup of the tags! [See more](https://lab.ruuvi.com/ruuvitag-fw/)
