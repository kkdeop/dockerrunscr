#!/bin/bash
apt update
apt upgrade
apt install -y unzip wget
wget https://labs.riseup.net/code/attachments/download/1423/OpenVPN_over_Tor_in_Tails_2.4.x.sh
mv OpenVPN_over_Tor_in_Tails_2.4.x.sh  installVPN.sh
chmod 777 installVPN.sh
wget https://freevpn.me/FreeVPN.me-OpenVPN-Bundle.zip
unzip FreeVPN.me-OpenVPN-Bundle.zip
mkdir /home/amnesia/
mkdir /home/amnesia/Persistent
cp FreeVPN.me-OpenVPN-Bundle/5\ -\ FreeVPN.be/FreeVPN.be-TCP443.ovpn /home/amnesia/Persistent/vpn.ovpn
bash installVPN.sh
