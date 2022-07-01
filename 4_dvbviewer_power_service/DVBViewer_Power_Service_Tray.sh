#!/bin/bash

function get_config(){
cfg=($(cat DVBViewer_Power_Service.cfg))

server_power=${cfg[0]}
server_boot_time=${cfg[1]}
server_poweron_ssh=${cfg[2]}
server_poweron_nfs=${cfg[3]}
server_poweron_smb=${cfg[4]}
server_poweron_hosts=${cfg[5]}
server_url=${cfg[6]}
server_user=${cfg[7]}
server_pass=${cfg[8]}

#remove quotes
temp="${server_power%\'}"
server_power="${temp#\'}"

temp="${server_boot_time%\'}"
server_boot_time="${temp#\'}"

temp="${server_poweron_ssh%\'}"
server_poweron_ssh="${temp#\'}"

temp="${server_poweron_nfs%\'}"
server_poweron_nfs="${temp#\'}"

temp="${server_poweron_smb%\'}"
server_poweron_smb="${temp#\'}"

temp="${server_poweron_hosts%\'}"
server_poweron_hosts="${temp#\'}"

temp="${server_url%\'}"
server_url="${temp#\'}"

temp="${server_user%\'}"
server_user="${temp#\'}"

temp="${server_pass%\'}"
server_pass="${temp#\'}"
}

get_config

reccount=5
STATUSIC="blue.png"

function get_status(){
    status2=$(wget --timeout=3 --tries=1 --no-check-certificate -qO- --user $server_user --password $server_pass $server_url/api/status2.html)

    # set STATUSIC and TOOLTIP depending on the reccount
    reccount=$(echo "$status2"|grep -Po '(?<=<reccount>)[^<]+')

    pidof -x -q DVBViewer_Power_Service.sh  &>/dev/null

    if [ "$?" = "0" ]
    then

        if [ -z "$reccount" ]
        then
            STATUSIC="gray.png"
            TOOLTIP="server not reachable"
        else

            if [ "$reccount" -gt "0" ] 
            then
                STATUSIC="red.png"
                TOOLTIP="recording in progress"
            fi

            if [ "$reccount" -eq "0" ] 
            then
               STATUSIC="blue.png"
               TOOLTIP="no recordings"
            fi

       fi 
  
    else

        if [ -z "$reccount" ]
        then
            STATUSIC="gray_warn.png"
            TOOLTIP="server not reachable - DVBViewer Power Service stopped"
        else

            if [ "$reccount" -gt "0" ] 
            then
                STATUSIC="red_warn.png"
                TOOLTIP="recording in progress - DVBViewer Power Service stopped"
            fi

            if [ "$reccount" -eq "0" ] 
            then
               STATUSIC="blue_warn.png"
               TOOLTIP="no recordings - DVBViewer Power Service stopped"
            fi
 
        fi
    fi

}

get_status

# create pipe
PIPE="$HOME/.pipe.tmp"
rm $PIPE &>/dev/null
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

# stop DVBViewer_Power_Service_Tray.sh if no user logged in
anzahl_user_long=$(who --count|grep "^\#")
anzahl_user_short=$(echo ${anzahl_user_long#*=})
[ $anzahl_user_short = 0 ] && "kill_tray.sh"

done #--------------------------------------------------------------------------------------------------

