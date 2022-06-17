#!/bin/bash

clear
#set variables-----------------------------------------------------------------
#
#installation destination folder
dest=~/bin/dvb
#
#wine binary
wine_version=$dest/wine/bin/wine
#
#oscam binary
echo choose oscam binary file
oscam_bin=$(yad --file --width=800 --height=600 --title="oscam file") &>/dev/null
if [ $? = 1 ]
then
echo installation aborted
exit
fi
#
#installation source folder
installsource="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
#
#
#------------------------------------------------------------------------------
#
#
mkdir $dest/oscam &>/dev/null
mkdir $dest/oscam/conf &>/dev/null
mkdir $dest/oscam/tmp &>/dev/null
#
#------------------------------------------------------------------------------
echo Copy oscam binary
cp -T "$oscam_bin" $dest/oscam/oscam.bin
#mv -f -T $dest/oscam/* oscam.bin
#
chmod +x $dest/oscam/oscam.bin
#
#
#
#dvbvserver.service
echo "[Unit]" > $dest"/dvbviewer/oscam.service"
echo "Description=Run oscam Service" >> $dest"/dvbviewer/oscam.service"
echo  >> $dest"/dvbviewer/oscam.service"
echo "[Service]" >> $dest"/dvbviewer/oscam.service"
#echo "User="$USER >> $dest"/dvbviewer/oscam.service"
echo "ExecStart=$dest/oscam/oscam.bin --config-dir $dest/oscam/conf  --temp-dir $dest/oscam/tmp" >> $dest"/dvbviewer/oscam.service"
echo "Restart=always" >> $dest"/dvbviewer/oscam.service"
echo  >> $dest"/dvbviewer/oscam.service"
echo "[Install]" >> $dest"/dvbviewer/oscam.service"
echo "WantedBy=multi-user.target" >> $dest"/dvbviewer/oscam.service"
#
#
sudo cp $dest/dvbviewer/oscam.service /etc/systemd/system/
sudo systemctl enable oscam.service
sudo systemctl start oscam.service
rm $dest/dvbviewer/oscam.service
#
echo ready
#

