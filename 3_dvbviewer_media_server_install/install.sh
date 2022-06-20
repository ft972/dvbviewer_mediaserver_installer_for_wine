#!/bin/bash
waiting_for_wineserver() {
    SERVICE="wineserver"
    echo -n "Waiting for wineserver to finish"
    while pgrep -x "$SERVICE" >/dev/null
    do
    sleep 1s
    echo -n .
    done
    echo
    sleep 2s
}
#
clear
#
#set variables-----------------------------------------------------------------
#
#installation destination folder
dest=~/bin/dvb
#
#installation source folder
installsource="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
#
#wine binary
wine_version=$dest/wine/bin/wine
#
#
# DVBViewer Media Server setup file
echo Choose DVBViewer Media Server setup file
dmsinst=$(yad --file --width=800 --height=600 --title="DVBViewer Media Server setup file") &>/dev/null
if [ $? = 1 ]
then
echo installation aborted
exit
fi
#
#
#Check if DVBVServer is running
pidof -q DVBVservice.exe  &>/dev/null
if [ "$?" = "0" ]
then
    echo DVBVServer is running. Must be terminated.
    sudo systemctl stop dvbvserver.service
fi
#
#
# change dvbviewer prefix to Windows 7
waiting_for_wineserver
env WINEPREFIX=$dest/dvbviewer $wine_version winecfg /v win7  &>/dev/null
#
echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "At the end of the installation, DO NOT display the web interface"
echo "and DO NOT start the configuration."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
#install DVBViewer Server
echo Installation of DVBViewer Server
env WINEPREFIX=$dest/dvbviewer $wine_version "$dmsinst" &>/dev/null
#
env WINEPREFIX=$dest/dvbviewer $dest/wine/bin/wineserver -k
#
#
# create icons-----------------------------------------------------------------
echo Create icons
cd "$dest/dvbviewer/drive_c/Program Files/DVBViewer"
wrestool -x --output=./DVBVCtrl.ico -t14 ./DVBVCtrl.exe
icotool -x --width=48 --bit-depth=32 DVBVCtrl.ico
mv -f DVBVCtrl*.png -T "DVBVCtrl.png"
#
cd "$dest/dvbviewer/drive_c/Program Files/DVBViewer"
wrestool -x --output=./svcoptions.ico -t14 ./svcoptions.exe
icotool -x --width=48 --bit-depth=32 svcoptions.ico
mv -f svcoptions*.png -T "svcoptions.png"
#
#create start script
echo Create start script
#DVBVCtrl
echo "#!/bin/bash" > $dest"/dvbviewer/dvbctrl_start.sh"
echo "export WINEPREFIX="$dest"/dvbviewer" >> $dest"/dvbviewer/dvbctrl_start.sh"
echo "env WINEPREFIX=$dest/dvbviewer $wine_version C:\\\\\Program\\ Files\\\\\\DVBViewer\\\\\\DVBVCtrl.exe" >> $dest"/dvbviewer/dvbctrl_start.sh"
chmod +x $dest"/dvbviewer/dvbctrl_start.sh"
#
#svcoptions
echo "#!/bin/bash" > $dest"/dvbviewer/svcoptions_start.sh"
echo "export WINEPREFIX="$dest"/dvbviewer" >> $dest"/dvbviewer/svcoptions_start.sh"
echo "env WINEPREFIX=$dest/dvbviewer $wine_version C:\\\\\Program\\ Files\\\\\\DVBViewer\\\\\\svcoptions.exe" >> $dest"/dvbviewer/svcoptions_start.sh"
chmod +x $dest"/dvbviewer/svcoptions_start.sh"
#
#
#
# create starter-------------------------------------------------------------
echo Create starter
#
#svcoptions
echo "[Desktop Entry]" > ~/.local/share/applications/svcoptions.desktop
echo "Name=DVBV-SVCOptions" >> ~/.local/share/applications/svcoptions.desktop
echo "Exec="$dest"/dvbviewer/svcoptions_start.sh" >> ~/.local/share/applications/svcoptions.desktop
echo "Type=Application" >> ~/.local/share/applications/svcoptions.desktop
echo "StartupNotify=true" >> ~/.local/share/applications/svcoptions.desktop
echo "Path="$dest"/dvbviewer/dosdevices/c:/" >> ~/.local/share/applications/svcoptions.desktop
echo "Icon="$dest"/dvbviewer/drive_c/Program Files/DVBViewer/svcoptions.png" >> ~/.local/share/applications/svcoptions.desktop
echo "Categories=AudioVideo;Video;TV"  >> ~/.local/share/applications/svcoptions.desktop
chmod +x ~/.local/share/applications/svcoptions.desktop
#
#
#
# create service
echo Create service
env WINEPREFIX=$dest/dvbviewer $wine_version regedit $installsource/dvbv_service.reg &>/dev/null
#
#dvbvserver.service
echo "[Unit]" > $dest"/dvbviewer/dvbvserver.service"
echo "Description=Run DVBViewer Recording Service in Wine" >> $dest"/dvbviewer/dvbvserver.service"
echo  >> $dest"/dvbviewer/dvbvserver.service"
echo "[Service]" >> $dest"/dvbviewer/dvbvserver.service"
echo "User="$USER >> $dest"/dvbviewer/dvbvserver.service"
echo "ExecStart=$dest/dvbviewer/dvbvserver_service_start.sh" >> $dest"/dvbviewer/dvbvserver.service"
echo "ExecStop=$dest/dvbviewer/dvbvserver_service_stop.sh" >> $dest"/dvbviewer/dvbvserver.service"
echo "Restart=always" >> $dest"/dvbviewer/dvbvserver.service"
echo "KillMode=process" >> $dest"/dvbviewer/dvbvserver.service"
echo  >> $dest"/dvbviewer/dvbvserver.service"
echo "[Install]" >> $dest"/dvbviewer/dvbvserver.service"
echo "WantedBy=multi-user.target" >> $dest"/dvbviewer/dvbvserver.service"
#
#dvbvserver.service start script
echo "#!/bin/bash" > $dest"/dvbviewer/dvbvserver_service_start.sh"
echo >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo 'echo $(date "+%F %H:%M:%S")" - dvbvservice started or restarted" >> '$dest"/dvbviewer/dvbvserver_service.log" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "xvfb-run --server-args=\"-screen 0 1920x1080x24\" env WINEPREFIX=$dest/dvbviewer $dest/wine/bin/wine explorer.exe /desktop&" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "sleep 60" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "env WINEPREFIX=$dest/dvbviewer $dest/wine/bin/wine cmd /c \"net start DVBVRecorder\"" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "sleep 20" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "while(true); do" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "  pidof DVBVservice.exe" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "     if [ "'$?'" -gt "0" ]" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "    then" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo '        echo $(date "+%F %H:%M:%S")" - DVBVservice.exe crashed, stop dvbviewer bottle" >> '$dest"/dvbviewer/dvbvserver_service.log" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "        $dest/dvbviewer/dvbvserver_service_stop.sh" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "        exit" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "    fi" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "  sleep 10" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
echo "done" >> $dest"/dvbviewer/dvbvserver_service_start.sh"
chmod +x $dest"/dvbviewer/dvbvserver_service_start.sh"
#
#
#
#dvbvserver.service stop script
echo "#!/bin/bash" > $dest"/dvbviewer/dvbvserver_service_stop.sh"
echo >> $dest"/dvbviewer/dvbvserver_service_stop.sh"
echo "env WINEPREFIX=$dest/dvbviewer $dest/wine/bin/wine cmd /c \"net stop DVBVRecorder\"" >> $dest"/dvbviewer/dvbvserver_service_stop.sh"
echo "sleep 2" >> $dest"/dvbviewer/dvbvserver_service_stop.sh"
echo "env WINEPREFIX=$dest/dvbviewer $dest/wine/bin/wineserver -k" >> $dest"/dvbviewer/dvbvserver_service_stop.sh"
echo 'echo $(date "+%F %H:%M:%S")" - dvbvservice stopped" >> '$dest"/dvbviewer/dvbvserver_service.log" >> $dest"/dvbviewer/dvbvserver_service_stop.sh"
chmod +x $dest"/dvbviewer/dvbvserver_service_stop.sh"
#
#
#switch to WindowsXP-----------------------------------------------------------
echo Change dvbviewer prefix to WindowsXP
env WINEARCH=win32 env WINEPREFIX=$dest/dvbviewer $wine_version winecfg /v winxp &>/dev/null
#
sudo cp $dest/dvbviewer/dvbvserver.service /etc/systemd/system/
sudo systemctl enable dvbvserver.service
sudo systemctl start dvbvserver.service
rm $dest/dvbviewer/dvbvserver.service
#
#
#ready
echo "-----------------------------------------------"
echo "Ready. The media server is accessible in 60s."
echo "-----------------------------------------------"




