#!/bin/bash

clear
newline=$'\n'
read -p "Insert backup file name configuarion: " backupname

backup=$(sudo cp /etc/network/interfaces $backupname)
echo $backup
echo "Backup process has been successful -- DONE!"

echo "${newline}"
read -p "Address: " ip
read -p "netmask: " netmask
read -p "network: " network

echo "# interfaces (5) file used by ifup(8) and ifdown(8)
#INTERFACE LOOPBACK
auto lo
iface lo inet loopback
${newline}
auto ens33
iface ens33 inet static
address $ip
netmask $netmask
network $network${newline}" > /etc/network/interfaces
echo "${newline}"

ifdown=$(sudo ifdown ens33)
echo $ifdown

ifup=$(sudo ifup ens33)
echo $ifup

echo "IP address configuration has been successful -- DONE!${newline}"
