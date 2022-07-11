dvbviewer_mediaserver_installer_for_wine
========================================
Scripts for installing the [DVBViewer Media Server](https://dvbviewer.com/) in Debian / Ubuntu based Linux under Wine.
Developed and tested with Linux Mint 20.3.
Please do not install in a productive environment. This is still a beta version.

System requirements
-------------------
- The setup files from DVBViewerPro and Mediaserver with a valid license
- Distribution: Debian or Ubuntu based
- Desktop environment: Cinnamon, Mate, Plasma, Xfce

In principle, other distributions are also possible. The following requirements must be met:
- The dependencies listed under "point 1_system_packages_install" must be installed and multiarch must be enabled for i386. This must be done manually the installer from point "1_system_packages_install" does not work outside of Debian / Ubuntu.
- The desktop environment must support tray icons. Unfortunately, in Gnome 3, for example, this is only possible with [extensions](https://github.com/phocean/TopIcons-plus).


1_system_packages_install
-------------------------
Make the file install.sh executable and run it in a shell. This will install all necessary dependencies and tools and set multiarch to i386.
The following packages/tools are needed:
32 bit version of Wine & gstreamer, yad, wget, tar, pidof, pgrep, unzip, wrestool, icotool, sed, 7z, cabextract, rtcwake, convert (imagemagick), xvfb

2_dvbviewer_install
-------------------
Make the file install.sh executable and run it in a shell.

3_dvbviewer_media_server_install
--------------------------------
Make the file install.sh executable and run it in a shell.

4_dvbviewer_power_service_install
---------------------------------
Make the file install.sh executable and run it in a shell.

