#!/bin/bash


cfg=($(cat DVBViewer_Power_Service.cfg))
server_power=${cfg[0]}
server_boot_time=${cfg[1]}
server_url=${cfg[2]}
server_user=${cfg[3]}
server_pass=${cfg[4]}

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
--form \
--buttons-layout=edge \
--item-separator="," \
--separator=" " \
--field="   energy saving mode":CBE $power_cbe \
--field="   server start time before recording start in min":NUM "$server_boot_time,0..15" \
--field="   DVBViewer Media Server web interface http[s]://IP:Port    ":TEXT $server_url \
--field="   user (if assigned; otherwise empty)":TEXT $server_user \
--field="   password (if assigned; otherwise empty)":TEXT $server_pass \
--button="OK:10" \
--button="Cancel:20"))
button_press="$?"



if [ "$button_press" = "10" ]
then
echo ${cfg[*]} > DVBViewer_Power_Service.cfg
fi





