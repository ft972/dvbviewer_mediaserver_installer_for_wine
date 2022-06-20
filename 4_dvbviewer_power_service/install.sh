#!/bin/bash

clear
#set variables-----------------------------------------------------------------
#
#installation destination folder
dest=~/bin/dvb
#
#
#installation source folder
installsource="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
#
mkdir $dest/dvbviewer_power_service  &>/dev/null
#
cp $installsource/DVBViewer_Power_Service.cfg $dest/dvbviewer_power_service/
cp $installsource/DVBViewer_Power_Service.sh $dest/dvbviewer_power_service/
cp $installsource/DVBViewer_Power_Service_Config.sh $dest/dvbviewer_power_service/
cp $installsource/dialog-error.png $dest/dvbviewer_power_service/
cp $installsource/DVBViewer_Power_Service_Tray.sh $dest/dvbviewer_power_service/
cp $installsource/kill_tray.sh $dest/dvbviewer_power_service/
cp $installsource/dvbserver_start.sh $dest/dvbviewer_power_service/
cp $installsource/dvbserver_stop.sh $dest/dvbviewer_power_service/
cp $installsource/dvbserver_ps_start.sh $dest/dvbviewer_power_service/
cp $installsource/dvbserver_ps_stop.sh $dest/dvbviewer_power_service/
cp $installsource/webinterface.sh $dest/dvbviewer_power_service/

#
cp "$dest/dvbviewer/drive_c/Program Files/DVBViewer/DVBVCtrl.png" $dest/dvbviewer_power_service/
cp "$dest/dvbviewer/drive_c/Program Files/DVBViewer/DVBViewer.png" $dest/dvbviewer_power_service/
#
chmod +x $dest/dvbviewer_power_service/DVBViewer_Power_Service.sh
chmod +x $dest/dvbviewer_power_service/DVBViewer_Power_Service_Config.sh
chmod +x $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
chmod +x $dest/dvbviewer_power_service/kill_tray.sh
chmod +x $dest/dvbviewer_power_service/dvbserver_start.sh
chmod +x $dest/dvbviewer_power_service/dvbserver_stop.sh
chmod +x $dest/dvbviewer_power_service/dvbserver_ps_start.sh
chmod +x $dest/dvbviewer_power_service/dvbserver_ps_stop.sh
chmod +x $dest/dvbviewer_power_service/webinterface.sh
#
sed -i -e "s#DVBViewer_Power_Service.cfg#$dest/dvbviewer_power_service/DVBViewer_Power_Service.cfg#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service.sh
sed -i -e "s#DVBViewer_Power_Service.log#$dest/dvbviewer_power_service/DVBViewer_Power_Service.log#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service.sh
sed -i -e "s#DVBViewer_Power_Service.cfg#$dest/dvbviewer_power_service/DVBViewer_Power_Service.cfg#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Config.sh
sed -i -e "s#DVBViewer_Power_Service.cfg#$dest/dvbviewer_power_service/DVBViewer_Power_Service.cfg#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
#
sed -i -e "s#dvbserver_start.sh#$dest/dvbviewer_power_service/dvbserver_start.sh#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#dvbserver_stop.sh#$dest/dvbviewer_power_service/dvbserver_stop.sh#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#DVBViewer_Power_Service_Config.sh#$dest/dvbviewer_power_service/DVBViewer_Power_Service_Config.sh#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#kill_tray.sh#$dest/dvbviewer_power_service/kill_tray.sh#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#svcoptions_start.sh#$dest/dvbviewer/svcoptions_start.sh#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#dvbserver_ps_start.sh#$dest/dvbviewer_power_service/dvbserver_ps_start.sh#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#dvbserver_ps_stop.sh#$dest/dvbviewer_power_service/dvbserver_ps_stop.sh#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#webinterface.sh#$dest/dvbviewer_power_service/webinterface.sh#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
#
sed -i -e "s#oscam_dir#$dest/oscam#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
#
sed -i -e "s#dialog-error.png#$dest/dvbviewer_power_service/dialog-error.png#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#DVBVCtrl.png#$dest/dvbviewer_power_service/DVBVCtrl.png#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#DVBViewer.png#$dest/dvbviewer_power_service/DVBViewer.png#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh



# create starter-------------------------------------------------------------
echo Create starter
#DVBViewer_Power_Service_Config
echo "[Desktop Entry]" > ~/.local/share/applications/DVBViewer_Power_Service_Config.desktop
echo "Name=DVBViewer Power Service Configuration" >> ~/.local/share/applications/DVBViewer_Power_Service_Config.desktop
echo "Exec="$dest"/dvbviewer_power_service/DVBViewer_Power_Service_Config.sh" >> ~/.local/share/applications/DVBViewer_Power_Service_Config.desktop
echo "Type=Application" >> ~/.local/share/applications/DVBViewer_Power_Service_Config.desktop
echo "StartupNotify=true" >> ~/.local/share/applications/DVBViewer_Power_Service_Config.desktop
echo "Path="$dest"/dvbviewer_power_service" >> ~/.local/share/applications/DVBViewer_Power_Service_Config.desktop
echo "Icon="$dest"/dvbviewer/drive_c/Program Files/DVBViewer/svcoptions.png" >> ~/.local/share/applications/DVBViewer_Power_Service_Config.desktop
echo "Categories=AudioVideo;Video;TV"  >> ~/.local/share/applications/DVBViewer_Power_Service_Config.desktop
chmod +x ~/.local/share/applications/DVBViewer_Power_Service_Config.desktop
#
#
#DVBViewer_Power_Service_Tray
echo "[Desktop Entry]" > ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
echo "Name=DVBViewer Power Service Tray" >> ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
echo "Exec="$dest"/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh" >> ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
echo "Type=Application" >> ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
echo "StartupNotify=false" >> ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
echo "Path="$dest"/dvbviewer_power_service" >> ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
echo "Icon="$dest"/dvbviewer/drive_c/Program Files/DVBViewer/svcoptions.png" >> ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
echo "Categories=AudioVideo;Video;TV"  >> ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
chmod +x ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
#
cp ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop ~/.config/autostart/
#
#dvbvserver.service
echo "[Unit]" > $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo "Description=Run DVBViewer Recording Power Service" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo  >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo "[Service]" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
#echo "User="$USER >> $dest"/dvbviewer/dvbvserver_power.service"
echo "ExecStart=$dest/dvbviewer_power_service/DVBViewer_Power_Service.sh" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo "Restart=always" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo  >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo "[Install]" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo "WantedBy=multi-user.target" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
#
#
sudo cp $dest/dvbviewer_power_service/dvbvserver_power.service /etc/systemd/system/
sudo systemctl enable dvbvserver_power.service
sudo systemctl start dvbvserver_power.service
rm $dest/dvbviewer_power_service/dvbvserver_power.service
#
echo Start Tray
$dest"/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh"&
disown
#
echo Ready
#

