#!/bin/bash
#
IS_SUDO=$(groups|grep sudo)
if [ -z "$IS_SUDO" ]
then
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "User \"$USER\" is not a member of the sudo group."
echo "Please add him to this group before installation the DVBViewer."
echo "Please run this command in a root shell: \"usermod -a -G sudo $USER\""
echo "or use the graphical user manager."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
exit
fi
#
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
cp $installsource/DVBViewer_Power_Service_Tray.sh $dest/dvbviewer_power_service/
cp $installsource/kill_tray.sh $dest/dvbviewer_power_service/
cp $installsource/dvbserver_start.sh $dest/dvbviewer_power_service/
cp $installsource/dvbserver_stop.sh $dest/dvbviewer_power_service/
cp $installsource/dvbserver_ps_start.sh $dest/dvbviewer_power_service/
cp $installsource/dvbserver_ps_stop.sh $dest/dvbviewer_power_service/
cp $installsource/webinterface.sh $dest/dvbviewer_power_service/

#
cp $installsource"/warning.png" $dest/dvbviewer_power_service/
cp "$dest/dvbviewer/drive_c/Program Files/DVBViewer/DVBViewer.png" $dest/dvbviewer_power_service/
convert $dest/"dvbviewer_power_service/DVBViewer.png" -colorspace gray -fill gray -tint 100 $dest/"dvbviewer_power_service/gray.png"
convert $dest/"dvbviewer_power_service/DVBViewer.png" -colorspace gray -fill "#cc0000" -tint 100 $dest/"dvbviewer_power_service/red.png"
convert $dest/"dvbviewer_power_service/DVBViewer.png" -colorspace gray -fill "#0b5394" -tint 100 $dest/"dvbviewer_power_service/blue.png"
#
composite -compose atop  $dest/"dvbviewer_power_service/warning.png" $dest/"dvbviewer_power_service/red.png" $dest/"dvbviewer_power_service/red_warn.png"
composite -compose atop  $dest/"dvbviewer_power_service/warning.png" $dest/"dvbviewer_power_service/gray.png" $dest/"dvbviewer_power_service/gray_warn.png"
composite -compose atop  $dest/"dvbviewer_power_service/warning.png" $dest/"dvbviewer_power_service/blue.png" $dest/"dvbviewer_power_service/blue_warn.png"
#
rm $dest/"dvbviewer_power_service/DVBViewer.png" 
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
sed -i -e "s#gray.png#$dest/dvbviewer_power_service/gray.png#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#blue.png#$dest/dvbviewer_power_service/blue.png#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#red.png#$dest/dvbviewer_power_service/red.png#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
#
sed -i -e "s#gray_warn.png#$dest/dvbviewer_power_service/gray_warn.png#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#blue_warn.png#$dest/dvbviewer_power_service/blue_warn.png#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh
sed -i -e "s#red_warn.png#$dest/dvbviewer_power_service/red_warn.png#g" $dest/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh


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
echo "Icon="$dest"/dvbviewer_power_service/blue.png" >> ~/.local/share/applications/DVBViewer_Power_Service_Tray.desktop
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
echo "User="$USER >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo "ExecStart=$dest/dvbviewer_power_service/DVBViewer_Power_Service.sh" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo "Restart=always" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo  >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo "[Install]" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
echo "WantedBy=multi-user.target" >> $dest"/dvbviewer_power_service/dvbvserver_power.service"
#
#
#permission to rtcwake whithout password
sudoers=$(sudo cat /etc/sudoers|grep $USER' ALL=(ALL) NOPASSWD: /sbin/rtcwake')
[ -z "$sudoers" ] && echo "$USER ALL=(ALL) NOPASSWD: /sbin/rtcwake" | sudo tee -a /etc/sudoers &>/dev/null
#
#permission to systemctl whithout password
sudoers=$(sudo cat /etc/sudoers|grep $USER' ALL=(ALL) NOPASSWD: /bin/systemctl')
[ -z "$sudoers" ] && echo "$USER ALL=(ALL) NOPASSWD: /bin/systemctl" | sudo tee -a /etc/sudoers &>/dev/null
#
#
sudo cp -f $dest/dvbviewer_power_service/dvbvserver_power.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable dvbvserver_power.service
sudo systemctl start dvbvserver_power.service
rm $dest/dvbviewer_power_service/dvbvserver_power.service
#
# Stop & start Tray
echo Stop Tray
pkill yad
pkill -f DVBViewer_Power_Service_Tray.sh
rm ~/.pipe.tmp &>/dev/null
#
echo Start Tray
$dest"/dvbviewer_power_service/DVBViewer_Power_Service_Tray.sh"&
disown
#
echo Ready.
#

