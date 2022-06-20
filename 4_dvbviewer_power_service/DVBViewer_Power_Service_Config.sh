#!/bin/bash


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



# if empty set to "unset"
[ -z "$server_poweron_hosts" ] && server_poweron_hosts="unset"
[ -z "$server_url" ] && server_url="unset"
[ -z "$server_user" ] && server_user="unset"
[ -z "$server_pass" ] && server_pass="unset"

s0='PowerON'
s1='Standby'
s3='Suspend-to-RAM'
s4='Suspend-to-disk'
s5='PowerOFF'


if [ "$s0" = "$server_power" ]
then
s0="^"$s0
fi
if [ "$s1" = "$server_power" ]
then
s1="^"$s1
fi
if [ "$s3" = "$server_power" ]
then
s3="^"$s3
fi
if [ "$s4" = "$server_power" ]
then
s4="^"$s4
fi
if [ "$s5" = "$server_power" ]
then
s5="^"$s5
fi

power_cbe=$s0","$s1","$s3","$s4","$s5


cfg=($(yad \
--title="DVBViewer Power Service Settings" \
--width=600 \
--quoted-output \
--form \
--buttons-layout=edge \
--item-separator="," \
--separator=" " \
--checklist \
--field="   energy saving mode":CB $power_cbe \
--field="   server start time before recording start in min":NUM "$server_boot_time,3..15" \
--field="   PowerON when ssh connection established":CHK $server_poweron_ssh \
--field="   PowerON when nfs4 connection established":CHK $server_poweron_nfs \
--field="   PowerON when smb connection established":CHK $server_poweron_smb \
--field="   PowerON if these computers pingable (comma separated)":TEXT $server_poweron_hosts \
--field="   DVBViewer Media Server web interface http[s]://IP:Port    ":TEXT $server_url \
--field="   user (if assigned; otherwise empty)":TEXT $server_user \
--field="   password (if assigned; otherwise empty)":TEXT $server_pass \
--button="OK:10" \
--button="Cancel:20"))
button_press="$?"


if [ "$button_press" = "10" ]
then
#replace unset with empty string 
temp=${cfg[*]}
cfg="${temp//unset/}"
#write configuration
echo $cfg > DVBViewer_Power_Service.cfg
fi





