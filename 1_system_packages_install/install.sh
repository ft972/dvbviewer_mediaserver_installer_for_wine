#!/bin/bash

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

BIT=$(getconf LONG_BIT)



clear
echo "Installation of the necessary packages to install and run"
echo "the DVBViewer Media Server."
echo 
echo "The following tools are used:"
echo "a 32 bit version of Wine"
echo "yad wget tar pidof pgrep unzip wrestool icotool sed 7z"
echo "cabextract rtcwake convert(imagemagick)"
echo ""

if [ $BIT = 64 ]
then
echo "64bit apt package manager found."
echo "Add multiarch support."
sudo dpkg --add-architecture i386
echo ""
echo "Update packages:"
echo ""
sudo apt-get update
echo ""
echo "Update package sources:"
echo ""
sudo apt-get install imagemagick wine32 wget unzip icoutils yad xvfb cabextract p7zip-full gstreamer1.0-tools:i386 gstreamer1.0-libav:i386 gstreamer1.0-plugins-bad:i386 gstreamer1.0-plugins-ugly:i386 ttf-mscorefonts-installer:i386
echo ""
echo "Ready"
exit
fi

if [ $BIT = 32 ]
then
echo "32bit apt package manager found."
echo ""
echo "Update package sources:"
echo ""
sudo apt-get update
echo ""
echo "Install packages:"
echo ""
sudo apt-get install imagemagick wine wget unzip icoutils yad xvfb cabextract p7zip-full gstreamer1.0-tools gstreamer1.0-libav gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly ttf-mscorefonts-installer
echo ""
echo "Ready"
exit
fi


