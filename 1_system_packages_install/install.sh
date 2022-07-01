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

apt-get --help &>/dev/null
if [ $? = 0 ]
then
PKGMANAGER=apt
fi

pacman --help  &>/dev/null
if [ $? = 0 ]
then
PKGMANAGER=pacman
fi

dnf --help  &>/dev/null
if [ $? = 0 ]
then
PKGMANAGER=dnf
fi


clear
echo "Installation of the necessary packages to install and run"
echo "the DVBViewer Media Server."
echo
echo "The scripts were created under Linux Mint. In other distributions,"
echo "other packages may be required."
echo 
echo "The following tools are used:"
echo "a 32 bit version of Wine"
echo "yad wget tar pidof pgrep unzip wrestool icotool sed 7z"
echo "cabextract rtcwake convert(imagemagick)"
echo ""

if [ $BIT = 64 ] && [ $PKGMANAGER = "apt" ]
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

if [ $BIT = 32 ] && [ $PKGMANAGER = "apt" ]
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

if [ $BIT = 64 ] && [ $PKGMANAGER = "pacman" ]
then
echo "64bit pacman package manager found."
echo ""
echo "Update package sources:"
echo ""
MULTILIB=$(sudo pacman -Syy|grep multilib)
if [ -z "$MULTILIB" ]
then
    echo "Please enable multilib support and restart this script."
    exit
else
echo ""
echo "Install packages:"
echo ""
sudo pacman -S imagemagick wine wget unzip icoutils yad xorg-server-xvfb cabextract p7zip lib32-gstreamer
echo ""
echo "Ready"
exit
fi
fi

if [ $BIT = 64 ] && [ $PKGMANAGER = "dnf" ]
then
echo "64bit dnf package manager found."
echo ""
echo "Check for available updates:"
echo ""
sudo dnf check-update
echo ""
echo "Install packages:"
echo ""
sudo dnf install ImageMagick wine.i686 wget unzip icoutils yad xorg-x11-server-Xvfb cabextract p7zip p7zip-plugins gstreamer1.i686 gstreamer1-plugins-bad-free.i686 gstreamer1-plugins-bad-free-extras.i686 gstreamer1-plugins-base.i686 gstreamer1-plugins-good.i686 gstreamer1-plugins-good-extras.i686 gstreamer1-plugins-ugly-free.i686 mscore-fonts-all
echo ""
echo "Ready"
exit
fi

echo "Package manager not recognized."
echo "Please install dependencies manually via your package manager."

