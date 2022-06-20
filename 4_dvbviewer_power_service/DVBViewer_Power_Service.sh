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


# Dokumentation: http://en.dvbviewer.tv/wiki/Recording_Service_web_API
timercount=0 #number of active timers (all kinds)
reccount=0 #number of ongoing recordings
nexttimer=0 #time in seconds until the next timer (all kinds) starts (-1 = no timer will start)
nextrec=0 #time in seconds until the next recording starts (-1 = no recording will start)
streamclientcount=0 #number of streaming clients (receiving data continuously)
rtspclientcount=0 #number of RTSP (Sat>IP) clients (may be more than 1 per DVBViewer instance)
unicastclientcount=0 #number of unicast clients
lastuiaccess=0 #time in seconds since the last web interface access (-1 = no access yet)
standbyblock=0 #indicates whether the RS currently blocks standby (0 = no, 1 = yes)
tunercount=0 #number of occupied tuners
streamtunercount=0 #number of tuners occupied by streaming clients (may be more than 1 client per tuner)
rectunercount=0 #number of tuners occupied by recordings (may intersect with streamtunercount)
epgudate=0 #epg update state: 0 = inactive, 1 = active, 2 = waiting for a free tuner
rights=0 #full (unlimited access to the API) read (only API functions which arn't changing anything permanently on the server are available)
recfiles=0 #number of files in the recording data base
recfolders=0 #avaiblable recording folders including folder, folder size, free disk space


function get_status(){
    
    # Check DVBViewer Media Server status---------------------------------------------------------------------------------------------
    status2=$(wget --timeout=3 --tries=1 --no-check-certificate -qO- --user $server_user --password $server_pass $server_url/api/status2.html)

    #next timer
    nexttimer=$(echo "$status2"|grep -Po '(?<=<nexttimer>)[^<]+')
    # If server not available do nothing
    if [ -z "$nexttimer" ]
    then
    #do nothing
    echo $nexttimer leer
    else
        #If no timer is set wake up in 24h
        if [ "$nexttimer" -eq "-1" ] 
        then
        nexttimer=86400
        fi
        #If the timer is scheduled later than in 24h, wake up in 24h
        if [ "$nexttimer" -gt "86400" ] 
        then
        nexttimer=86400
        fi
    fi

    #DVBV Media Server Status variables that must be 0 for switching off
    streamclientcount=$(echo "$status2"|grep -Po '(?<=<streamclientcount>)[^<]+')
    rtspclientcount=$(echo "$status2"|grep -Po '(?<=<rtspclientcount>)[^<]+')
    unicastclientcount=$(echo "$status2"|grep -Po '(?<=<unicastclientcount>)[^<]+')
    rectunercount=$(echo "$status2"|grep -Po '(?<=<rectunercount>)[^<]+')
    streamtunercount=$(echo "$status2"|grep -Po '(?<=<streamtunercount>)[^<]+')
    tunercount=$(echo "$status2"|grep -Po '(?<=<tunercount>)[^<]+')
    epgudate=$(echo "$status2"|grep -Po '(?<=<epgudate>)[^<]+')
    standbyblock=$(echo "$status2"|grep -Po '(?<=<standbyblock>)[^<]+')

    #Check whether users are logged on to the system----------------------------------------------------------------------------------
    anzahl_user_long=$(who --count|grep "^\#")
    anzahl_user_short=$(echo ${anzahl_user_long#*=})

    #Check if network connections established-----------------------------------------------------------------------------------------
    #set language to English    
    export LC_ALL=C
    # Check ssh
    ssh_active="0"
    if [ $server_poweron_ssh = "TRUE" ]
    then
        ssh_netstat=$(netstat --numeric-ports|grep ':22.*EST')
        if [ -n "$ssh_netstat" ]; then
        ssh_active="1"
        fi
    fi
    # Check nfs
    nfs_active="0"
    if [ $server_poweron_nfs = "TRUE" ]
    then
        nfs_netstat=$(netstat --numeric-ports|grep ':2049.*EST')
        if [ -n "$nfs_netstat" ]; then
        nfs_active="1"
        fi
    fi
    # Check smb
    smb_active="0"
    if [ $server_poweron_smb = "TRUE" ]
    then
        smb_netstat=$(netstat --numeric-ports|grep ':445.*EST')
        if [ -n "$smb_netstat" ]; then
        smb_active="1"
        fi
    fi
    #set language to native
    unset LC_ALL

    # Check if hosts pingable----------------------------------------------------------------------------------------------------------
    IFS=',' read -r -a hosts_array <<< "$server_poweron_hosts"
    ping_active=0
    for element in "${hosts_array[@]}"
    do
        ping -c 1 -W 2 "$element" &> /dev/null && ping_active="1"
    done

    # sum status
    power_status=$[streamclientcount+rtspclientcount+unicastclientcount+rectunercount+streamtunercount+tunercount+epgudate+standbyblock+anzahl_user_short+ssh_active+nfs_active+smb_active+ping_active]


}

echo $(date "+%F %H:%M:%S")" - DVBViewer Power Service started" >> DVBViewer_Power_Service.log
sleep 70 # waiting for dvbvservice

while true
do
    power_status_kummuliert="0"

    for i in {1..5}
    do 
        sleep 60
        get_config
        get_status

        #server not reachable
        if [ -z "$nexttimer" ]
        then
            echo "server not reachable"
            echo $(date "+%F %H:%M:%S")" - server not reachable" >> DVBViewer_Power_Service.log
            power_status_kummuliert="100"
            break
        fi

        power_status_kummuliert=$[power_status_kummuliert+power_status]
        
    done

    echo $(date "+%F %H:%M:%S")" - linux user:"$anzahl_user_short" - epg udate:"$epgudate" - standby block:"$standbyblock" - tuner used:"$tunercount" - ssh active:"$ssh_active" - nfs active:"$nfs_active" - smb active:"$smb_active" - host pingable:"$ping_active >> DVBViewer_Power_Service.log

    #If the boot time is greater than the next timer no energy saving
    no_power_save=$[nexttimer-server_boot_time*60-120]
    if [ "$no_power_save" -lt "0" ]
    then
    power_status_kummuliert=$[power_status_kummuliert+1]
    fi

    if [ "$power_status_kummuliert" = "0" ]
    then

        rtc_time=$[nexttimer-server_boot_time*60]
        echo $(date "+%F %H:%M:%S")" - $server_power - start in $rtc_time sec" >> DVBViewer_Power_Service.log

        if [ "$server_power" = "PowerON" ]
        then
        sleep 1
        fi

        if [ "$server_power" = "Standby" ]
        then
        rtcwake -m standby -s $rtc_time
        sleep 60
        echo $(date "+%F %H:%M:%S")" - woke up from $server_power" >> DVBViewer_Power_Service.log
        fi

        if [ "$server_power" = "Suspend-to-RAM" ]
        then
        rtcwake -m mem -s $rtc_time
        sleep 60
        echo $(date "+%F %H:%M:%S")" - woke up from $server_power" >> DVBViewer_Power_Service.log
        fi

        if [ "$server_power" = "Suspend-to-disk" ]
        then
        rtcwake -m disk -s $rtc_time
        sleep 60
        echo $(date "+%F %H:%M:%S")" - woke up from $server_power" >> DVBViewer_Power_Service.log
        fi

        if [ "$server_power" = "PowerOFF" ]
        then
        rtcwake -m off -s $rtc_time
        sleep 60
        echo $(date "+%F %H:%M:%S")" - woke up from $server_power" >> DVBViewer_Power_Service.log
        fi

        #Dokumentation: https://wiki.ubuntuusers.de/rtcwake/
        #rtcwake -m mem -s 60
        #rtcwake -m no -s 600 && sudo poweroff
    fi

done

