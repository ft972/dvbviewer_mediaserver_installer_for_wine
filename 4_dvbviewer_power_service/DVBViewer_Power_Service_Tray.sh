#!/bin/bash

function get_config(){
cfg=($(cat DVBViewer_Power_Service.cfg))
server_power=${cfg[0]}
server_boot_time=${cfg[1]}
server_url=${cfg[2]}
server_user=${cfg[3]}
server_pass=${cfg[4]}
}

get_config

reccount=5
STATUSIC="DVBVCtrl.png"

function get_status(){
    status2=$(wget --timeout=3 --tries=1 --no-check-certificate -qO- --user $server_user --password $server_pass $server_url/api/status2.html)

    # set STATUSIC and TOOLTIP depending on the reccount
    reccount=$(echo "$status2"|grep -Po '(?<=<reccount>)[^<]+')

    if [ -z "$reccount" ]
    then
       STATUSIC="dialog-error.png"
       TOOLTIP="server not reachable"
    else
       if [ "$reccount" -gt "0" ] 
       then
       STATUSIC="DVBViewer.png"
       TOOLTIP="recording in progress"
       fi

       if [ "$reccount" -eq "0" ] 
       then
       STATUSIC="DVBVCtrl.png"
       TOOLTIP="No recordings"
       fi
    fi

}

get_status

# create pipe
PIPE="$HOME/.pipe.tmp"
rm $PIPE
mkfifo $PIPE
exec 3<> $PIPE

# yad menu
yad --notification --image="$STATUSIC" --listen <&3 & 


while true #-----------------------------------------------------------------------------------------
do

get_config
get_status

if [ "$server_url_old" != "$server_url" ] # check if server_url has changed
then

if [ -d "oscam_dir" ]; # check if oscam is installed
then
# menu with oscam
echo "menu:\
Start Media Server!dvbserver_start.sh|\
Stop Media Server!dvbserver_stop.sh|\
Web Interface!"webinterface.sh $server_url"|\
Configure Server!svcoptions_start.sh|\
_______________________________________________________________!continue|\
Start DVBViewer Power Service!dvbserver_ps_start.sh|\
Stop DVBViewer Power Service!dvbserver_ps_stop.sh|\
Configure DVBViewer Power Service!DVBViewer_Power_Service_Config.sh|\
_______________________________________________________________!continue|\
Oscam Web Interface!"webinterface.sh http://127.0.0.1:8888"|\
_______________________________________________________________!continue|\
Exit!kill_tray.sh" >&3
else
# menu without oscam
echo "menu:\
Start Media Server!dvbserver_start.sh|\
Stop Media Server!dvbserver_stop.sh|\
Web Interface!"webinterface.sh $server_url"|\
Configure Server!svcoptions_start.sh|\
_______________________________________________________________!continue|\
Start DVBViewer Power Service!dvbserver_ps_start.sh|\
Stop DVBViewer Power Service!dvbserver_ps_stop.sh|\
Configure DVBViewer Power Service!DVBViewer_Power_Service_Config.sh|\
_______________________________________________________________!continue|\
Exit!kill_tray.sh" >&3
fi

fi


# icon of the symbol in the tray
echo "icon:$STATUSIC">&3

# tooltip of the symbol in the tray
echo "tooltip:$TOOLTIP" >&3


server_url_old=$server_url


sleep 10 
done #--------------------------------------------------------------------------------------------------

