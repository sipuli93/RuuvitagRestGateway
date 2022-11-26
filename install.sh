#!/bin/bash
#
# Sensor gateway for BLE advertisement messages to local server
#
#

servicename="ruuvitagrestgateway"
servicefile="/lib/systemd/system/$servicename.service"
destpath="/usr/share/$servicename"
servicelauncher="$destpath/ruuvitagrestgatewaykickstart.sh"
servicesettingsfile="/etc/ruuvitagrestgateway.cnf"
srcpath=`pwd`
repopath=$PWD


echo "Update system"
sudo apt-get --assume-yes update &&  sudo apt-get dist-upgrade && echo +++ upgrade successful +++

echo "Install bluetooth libraries"
sudo apt-get --assume-yes install bluetooth bluez blueman

echo "Install ruuvitag-sensor package"
sudo apt-get --assume-yes install bluez-hcidump && echo +++ install successful +++

yes | sudo pip3 install ruuvitag-sensor==1.1.0
yes | sudo pip3 install flask-restful==0.3.8
yes | sudo pip3 install flask_cors==3.0.10

echo "Install build packages and websocket python dependencies"
sudo apt-get --assume-yes install build-essential libssl-dev libffi-dev python-dev
sudo apt-get --assume-yes  install python-bluez

if [ -f "$servicefile" ]; then
    echo "Remove existing service"
    service $servicename stop
    systemctl disable $servicename
fi

sleep 2

if [ ! -d "$destpath" ]; then
    echo "Make dir $destpath"
    mkdir $destpath
fi

echo "Creating service"

if [ ! -f "$servicesettingsfile" ]; then
    # Settings file doesn't exists, write some defaults:
    echo "#
# Settings for RuuviTag BLE advertisement message gateway
#
[bluetooth]
# Raspberry's bluetooth interface
hci=0
" > $servicesettingsfile 
fi

echo "Write service file $serviceFile"
echo "[Unit]
Description=$servicename, RuuviTag BLE advertisement message gateway via RESTful flask api
After=bluetooth.target
[Service]
Type=simple
Restart=always
RestartSec=15
User=$USER
ExecStart=$servicelauncher
[Install]
WantedBy=default.target" > $servicefile

echo "Write launcher file $servicelauncher"

echo "#!/bin/bash
cd $repopath/gateway/
sudo /usr/bin/env python3 RuuvitagRestGateway.py
" > $servicelauncher

sudo chmod +x $servicelauncher
echo "Enable service"
systemctl enable $servicename

echo ""
echo "If everything went well, service can be started, stoped and status checked"
echo "by normal service commands, like:"
echo "   sudo service $servicename start"
echo "   sudo service $servicename status"
echo "   sudo service $servicename stop"
echo ""
