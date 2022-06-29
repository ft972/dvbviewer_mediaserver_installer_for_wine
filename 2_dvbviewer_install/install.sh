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
#Init dvbvderver_installiert
dvbvderver_installiert=0
#
#installation destination folder
dest=~/bin/dvb
#
#wine binary
wine_version=$dest/wine/bin/wine
#
#installation source folder
installsource="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
#
#DVBViewer setup file
#dvbviewerinst=DVBViewer_setup_7.1.2.1.exe
echo Choose DVBViewer Setup File
dvbviewerinst=$(yad --file --width=800 --height=600 --title="DVBViewer Setup File") &>/dev/null
if [ $? = 1 ]
then
echo installation aborted
exit
fi
#
#
#
#download additional software--------------------------------------------------
echo
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo Download additional software.
echo All downloads are stored in the installation source directory 
echo in the binary folder. 
echo A new installation does not require a new download if these downloads 
echo are still available.
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo
mkdir -p $installsource/binary &>/dev/null
cd $installsource/binary
#
if [ -f "$installsource/binary/PlayOnLinux-wine-7.0-upstream-linux-x86.tar.gz" ];
then
    echo "PlayOnLinux-wine-7.0-upstream-linux-x86.tar.gz already exists. Cancel download."
else
   echo Downloading PlayOnLinux-wine-7.0
   wget https://www.playonlinux.com/wine/binaries/phoenicis/upstream-linux-x86/PlayOnLinux-wine-7.0-upstream-linux-x86.tar.gz &>/dev/null
fi
#
if [ -f "$installsource/binary/wine-gecko-2.47.2-x86.msi" ];
then
    echo "wine-gecko-2.47.2-x86.msi already exists. Cancel download."
else
   echo Downloading wine-gecko-2.47
   wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.msi &>/dev/null
fi
#
if [ -f "$installsource/binary/DummyExe.exe" ];
then
    echo "DummyExe.exe already exists. Cancel download."
else
   echo Downloading DummyExe.exe
   wget https://github.com/Flightkick/DummyExe/releases/download/1.0.0/DummyExe.exe &>/dev/null
fi
#
if [ -f "$installsource/binary/madVR.zip" ];
then
    echo "madVR.zip already exists. Cancel download."
else
   echo Downloading MadVR
   wget http://madshi.net/madVR.zip &>/dev/null
fi
#
if [ -f "$installsource/binary/MatroskaSplitter.exe" ];
then
    echo "MatroskaSplitter.exe already exists. Cancel download."
else
   echo Downloading MatroskaSplitter
   wget http://haali.net/mkv/MatroskaSplitter.exe &>/dev/null
fi
#
#
if [ -f "$installsource/binary/dotNetFx40_Full_x86_x64.exe" ];
then
    echo "dotNetFx40_Full_x86_x64.exe already exists. Cancel download."
else
   echo Downloading dotNetFx40_Full_x86_x64.exe
   wget https://download.microsoft.com/download/9/5/A/95A9616B-7A37-4AF6-BC36-D6EA96C8DAAE/dotNetFx40_Full_x86_x64.exe &>/dev/null
fi
#
#
if [ -f "$installsource/binary/vc_redist.x86.exe" ];
then
    echo "vc_redist.x86.exe already exists. Cancel download."
else
   echo Downloading vc_redist.x86.exe
   wget https://aka.ms/vs/16/release/vc_redist.x86.exe &>/dev/null
fi
#
#
if [ -f "$installsource/binary/standalone_filters-mpc-be.1.5.6.6000.x86.7z" ];
then
    echo "standalone_filters-mpc-be.1.5.6.6000.x86.7z already exists. Cancel download."
else
   echo Downloading standalone_filters-mpc-be.1.5.6.6000.x86.7z
   wget https://master.dl.sourceforge.net/project/mpcbe/MPC-BE/Release%20builds/1.5.6/standalone_filters-mpc-be.1.5.6.6000.x86.7z &>/dev/null
fi
#
#
if [ -f "$installsource/binary/oleaut32.dll" ];
then
    echo "oleaut32.dll already exists. Cancel download."
else
   echo Downloading oleaut32.dll
   wget http://download.windowsupdate.com/msdownload/update/software/svpk/2011/02/windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe &>/dev/null
   cabextract -d "$installsource/binary" -L -F "x86_microsoft-windows-ole-automation_31bf3856ad364e35_6.1.7601.17514_none_bf07947959bc4c33/oleaut32.dll" "$installsource/binary"/windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe &>/dev/null
   mv "$installsource/binary/x86_microsoft-windows-ole-automation_31bf3856ad364e35_6.1.7601.17514_none_bf07947959bc4c33/oleaut32.dll" $installsource/binary &>/dev/null
   rm windows6.1-kb976932-x86_c3516bc5c9e69fee6d9ac4f981f5b95977a8a2fa.exe &>/dev/null
   rm -r "$installsource/binary/x86_microsoft-windows-ole-automation_31bf3856ad364e35_6.1.7601.17514_none_bf07947959bc4c33" &>/dev/null
fi
#
if [ -f "$installsource/binary/LAVFilters-0.76.1-Installer.exe" ];
then
    echo "LAVFilters-0.76.1-Installer.exe already exists. Cancel download."
else
   echo Downloading LAVFilters-0.76.1-Installer.exe
   wget https://github.com/Nevcairiel/LAVFilters/releases/download/0.76.1/LAVFilters-0.76.1-Installer.exe &>/dev/null
fi
#
#
#create directories------------------------------------------------------------
mkdir -p $dest &>/dev/null
mkdir $dest/dvbviewer &>/dev/null
mkdir $dest/wine &>/dev/null
mkdir -p ~/.local/share/applications/
#
#unpack wine-------------------------------------------------------------------
#
echo
echo Unpack wine
cd $dest/wine
tar xzf $installsource/binary/PlayOnLinux-wine-7.0-upstream-linux-x86.tar.gz
#
#copy gecko
echo "Copy gecko"
mkdir $dest/wine/share/wine/gecko &>/dev/null
cp $installsource/binary/wine-gecko-2.47.2-x86.msi $dest/wine/share/wine/gecko/
#
#
#Create WindowsXP 32bit dvbviewer prefix with disabled mono installer----------
export WINEDLLOVERRIDES="mscoree,winemenubuilder.exe="
echo Create WindowsXP 32bit dvbviewer prefix with disabled mono installer
env WINEARCH=win32 env WINEPREFIX=$dest/dvbviewer $wine_version winecfg /v winxp &>/dev/null
#
#
#------------------------------------------------------------------------------
#Check if DVBVServer is running
echo Check if DVBVServer is running
pidof -q DVBVservice.exe  &>/dev/null
if [ "$?" = "0" ]
then
    dvbvderver_installiert=1
    echo DVBVServer is running. Must be terminated.
    sudo systemctl stop dvbvserver.service
fi
#
#install Gecko-------------------------------------------------------------------------
#
waiting_for_wineserver
echo Installation of Gecko
env WINEPREFIX=$dest/dvbviewer $wine_version msiexec /i $dest/wine/share/wine/gecko/wine-gecko-2.47.2-x86.msi &>/dev/null
#
#wine registry settings---------------------------------------------------
waiting_for_wineserver
echo Set wine registry settings
env WINEARCH=win32 env WINEPREFIX=$dest/dvbviewer $wine_version reg.exe import $installsource/reg_wine.reg  &>/dev/null
#
#
# Installation oleaut32.dll----------------------------------------------------
echo Installation of oleaut32.dll
cp $installsource/binary/oleaut32.dll $dest/dvbviewer/drive_c/windows/system32
env env WINEPREFIX=$dest/dvbviewer $wine_version reg.exe import $installsource/oleaut32_DllOverride.reg &>/dev/null
#
# Installation VC++2019--------------------------------------------------------
echo Installation of VC++2019
env env WINEPREFIX=$dest/dvbviewer $wine_version $installsource/binary/vc_redist.x86.exe /Q &>/dev/null
env env WINEPREFIX=$dest/dvbviewer $wine_version reg.exe import $installsource/vcrun2019_DllOverride.reg &>/dev/null
#
#
#Install dotnet40---------------------------------------------------------
waiting_for_wineserver
echo -n Installation of dotnet40. This can take a few minutes. Please be patient.
sleep 1s
echo -n .
env env WINEPREFIX=$dest/dvbviewer $wine_version $installsource/binary/dotNetFx40_Full_x86_x64.exe /Q &>/dev/null
echo -n .
env env WINEPREFIX=$dest/dvbviewer $wine_version reg.exe import $installsource/dotnet40_DllOverride.reg &>/dev/null
echo -n .
env env WINEPREFIX=$dest/dvbviewer $wine_version reg add "HKLM\\Software\\Microsoft\\NET Framework Setup\\NDP\\v4\\Full" /v Install /t REG_DWORD /d 0001 /f &>/dev/null
echo -n .
env env WINEPREFIX=$dest/dvbviewer $wine_version reg add "HKLM\\Software\\Microsoft\\NET Framework Setup\\NDP\\v4\\Full" /v Version /t REG_SZ /d "4.0.30319" /f &>/dev/null
echo -n .
env env WINEPREFIX=$dest/dvbviewer $wine_version $dest/dvbviewer/drive_c/windows/Microsoft.NET/Framework/v4.0.30319/ngen.exe executequeueditems &>/dev/null
echo -n .
env env WINEPREFIX=$dest/dvbviewer $wine_version reg add "HKLM\\Software\\Microsoft\\.NETFramework" /v OnlyUseLatestCLR /t REG_DWORD /d 0001 /f &>/dev/null
echo . 
echo Ready
#
#
#Switch to Windows 7-----------------------------------------------------------
env WINEARCH=win32 env WINEPREFIX=$dest/dvbviewer $wine_version winecfg /v win7 &>/dev/null
#
#
#Installation of MPC-BE Stanalone Filter------------------------------------------------------
echo Installation of MPC-BE Stanalone Filter
cd $dest/dvbviewer/drive_c/Program\ Files
7z x $installsource/binary/standalone_filters-mpc-be.1.5.6.6000.x86.7z  &>/dev/null
cd $dest/dvbviewer/drive_c/Program\ Files/standalone_filters-mpc-be.1.5.6.6000.x86
env WINEPREFIX=$dest/dvbviewer $wine_version regsvr32 *.ax  &>/dev/null
#
#
#Installation of MatroskaSplitter------------------------------------------------------
waiting_for_wineserver
echo Installation of MatroskaSplitter
env WINEPREFIX=$dest/dvbviewer $wine_version $installsource/binary/MatroskaSplitter.exe  &>/dev/null
#
waiting_for_wineserver
#
#install madVR
echo Installation of madVR
cd $dest/dvbviewer/drive_c/Program\ Files
unzip -o $installsource/binary/madVR.zip  &>/dev/null
cd $dest/dvbviewer/drive_c/Program\ Files/madVR
env WINEPREFIX=$dest/dvbviewer $wine_version regsvr32 madVR.ax  &>/dev/null
echo copy madVR settings
cp $installsource/binary/settings.bin $dest/dvbviewer/drive_c/Program\ Files/madVR/
#
waiting_for_wineserver
#
#Installation of LAVFilters------------------------------------------------------
waiting_for_wineserver
echo Installation of LAVFilters
env WINEPREFIX=$dest/dvbviewer $wine_version $installsource/binary/LAVFilters-0.76.1-Installer.exe &>/dev/null
#--------------------------------------------------------------------------------
#
#copy Dummy-powercfg.exe
echo copy Dummy-powercfg.exe
cp $installsource/binary/DummyExe.exe $dest/dvbviewer/drive_c/windows/system32/powercfg.exe
#
#
#install DVBViewer
echo Installation of DVBViewer
#
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "LavFilters are already installed."
echo "At the end of the installation, DO NOT display the changelog"
echo "and DO NOT start the DVBViewer."
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
#
env WINEPREFIX=$dest/dvbviewer $wine_version "$dvbviewerinst" /LOADINF="$installsource/dvbviewer-setup.inf" &>/dev/null
#       /SAVEINF="$installsource/dvbviewer-setup.inf"
#       /LOADINF="$installsource/dvbviewer-setup.inf"
#
env WINEPREFIX=$dest/dvbviewer $dest/wine/bin/wineserver -k
#
waiting_for_wineserver
#
if [ "$dvbvderver_installiert" = "1" ]
then
    echo Restart the DVBVserver.
    sudo systemctl start dvbvserver.service
fi
#
#
#check demo version
cd "$dest/dvbviewer/drive_c/Program Files/DVBViewer"
if [ -f "$dest/dvbviewer/drive_c/Program Files/DVBViewer/DVBViewerDemo.exe" ];
then
    echo "Demo version found. Create symlinks."
    ln -s DVBVDownloaderDemo.exe DVBVDownloader.exe
    ln -s DVBViewerDemo.exe DVBViewer.exe
    ln -s DVBViewerDemo.exe KeyTool.exe
fi
#
# create icons-----------------------------------------------------------------
echo Create icons
cd "$dest/dvbviewer/drive_c/Program Files/DVBViewer"
wrestool -x --output=./DVBViewer.ico -t14 ./DVBViewer.exe
icotool -x --width=48 --bit-depth=32 DVBViewer.ico 
mv -f DVBViewer*.png -T "DVBViewer.png"
#
wrestool -x --output=./DVBVDownloader.ico -t14 ./DVBVDownloader.exe
icotool -x --width=256 DVBVDownloader.ico 
mv -f DVBVDownloader*.png -T "DVBVDownloader.png"
#
wrestool -x --output=./KeyTool.ico -t14 ./KeyTool.exe
icotool -x --width=48 --bit-depth=32 KeyTool.ico 
mv -f KeyTool*.png -T "KeyTool.png"
#
#
#create start script
echo Create start script
#winecfg
echo "#!/bin/bash" > $dest"/dvbviewer/dvbviewer_winecfg_start.sh"
echo "export WINEPREFIX="$dest"/dvbviewer" >> $dest"/dvbviewer/dvbviewer_winecfg_start.sh"
echo "env WINEPREFIX=$dest/dvbviewer $wine_version winecfg" >> $dest"/dvbviewer/dvbviewer_winecfg_start.sh"
chmod +x $dest"/dvbviewer/dvbviewer_winecfg_start.sh"
#
#dvbviewer
echo "#!/bin/bash" > $dest"/dvbviewer/dvbviewer_start.sh"
echo "export WINEPREFIX="$dest"/dvbviewer" >> $dest"/dvbviewer/dvbviewer_start.sh"
echo "env WINEPREFIX=$dest/dvbviewer $wine_version C:\\\\\Program\\ Files\\\\\\DVBViewer\\\\\\DVBViewer.exe" >> $dest"/dvbviewer/dvbviewer_start.sh"
chmod +x $dest"/dvbviewer/dvbviewer_start.sh"
#
#DVBVDownloader
echo "#!/bin/bash" > $dest"/dvbviewer/dvbdownloader_start.sh"
echo "export WINEPREFIX="$dest"/dvbviewer" >> $dest"/dvbviewer/dvbdownloader_start.sh"
echo "env WINEPREFIX=$dest/dvbviewer $wine_version C:\\\\\Program\\ Files\\\\\\DVBViewer\\\\\\DVBVDownloader.exe" >> $dest"/dvbviewer/dvbdownloader_start.sh"
chmod +x $dest"/dvbviewer/dvbdownloader_start.sh"
#
#
#keytool
echo "#!/bin/bash" > $dest"/dvbviewer/keytool_start.sh"
echo "export WINEPREFIX="$dest"/dvbviewer" >> $dest"/dvbviewer/keytool_start.sh"
echo "env WINEPREFIX=$dest/dvbviewer $wine_version C:\\\\\Program\\ Files\\\\\\DVBViewer\\\\\\KeyTool.exe" >> $dest"/dvbviewer/keytool_start.sh"
chmod +x $dest"/dvbviewer/keytool_start.sh"
#
#dvbviewer_run_program
echo "#!/bin/bash" > $dest"/dvbviewer/dvbviewer_run_program.sh"
echo 'prog=$(yad --file --width=800 --height=600 --title="Select Windows Executable") &>/dev/null' >> $dest"/dvbviewer/dvbviewer_run_program.sh"
echo '[ $? = 1 ] && exit' >> $dest"/dvbviewer/dvbviewer_run_program.sh"
echo "export WINEPREFIX="$dest"/dvbviewer" >> $dest"/dvbviewer/dvbviewer_run_program.sh"
echo "env WINEPREFIX=$dest/dvbviewer $wine_version "'$prog' >> $dest"/dvbviewer/dvbviewer_run_program.sh"
chmod +x $dest"/dvbviewer/dvbviewer_run_program.sh"
#
#
#
# create starter-------------------------------------------------------------
echo Create starter
#winecfg
echo "[Desktop Entry]" > ~/.local/share/applications/DVBViewer-winecfg.desktop
echo "Name=DVBViewer winecfg" >> ~/.local/share/applications/DVBViewer-winecfg.desktop
echo "Exec="$dest"/dvbviewer/dvbviewer_winecfg_start.sh" >> ~/.local/share/applications/DVBViewer-winecfg.desktop
echo "Type=Application" >> ~/.local/share/applications/DVBViewer-winecfg.desktop
echo "StartupNotify=true" >> ~/.local/share/applications/DVBViewer-winecfg.desktop
echo "Path="$dest"/dvbviewer/dosdevices/c:/" >> ~/.local/share/applications/DVBViewer-winecfg.desktop
echo "Icon="$dest"/dvbviewer/drive_c/Program Files/DVBViewer/DVBViewer.png" >> ~/.local/share/applications/DVBViewer-winecfg.desktop
echo "Categories=AudioVideo;Video;TV"  >> ~/.local/share/applications/DVBViewer-winecfg.desktop
chmod +x ~/.local/share/applications/DVBViewer-winecfg.desktop
#
#dvbviewer
echo "[Desktop Entry]" > ~/.local/share/applications/DVBViewer.desktop
echo "Name=DVBViewer" >> ~/.local/share/applications/DVBViewer.desktop
echo "Exec="$dest"/dvbviewer/dvbviewer_start.sh" >> ~/.local/share/applications/DVBViewer.desktop
echo "Type=Application" >> ~/.local/share/applications/DVBViewer.desktop
echo "StartupNotify=true" >> ~/.local/share/applications/DVBViewer.desktop
echo "Path="$dest"/dvbviewer/dosdevices/c:/" >> ~/.local/share/applications/DVBViewer.desktop
echo "Icon="$dest"/dvbviewer/drive_c/Program Files/DVBViewer/DVBViewer.png" >> ~/.local/share/applications/DVBViewer.desktop
echo "Categories=AudioVideo;Video;TV"  >> ~/.local/share/applications/DVBViewer.desktop
chmod +x ~/.local/share/applications/DVBViewer.desktop
#
#dvbdownloader
echo "[Desktop Entry]" > ~/.local/share/applications/DVBVDownloader.desktop
echo "Name=DVBVDownloader" >> ~/.local/share/applications/DVBVDownloader.desktop
echo "Exec="$dest"/dvbviewer/dvbdownloader_start.sh" >> ~/.local/share/applications/DVBVDownloader.desktop
echo "Type=Application" >> ~/.local/share/applications/DVBVDownloader.desktop
echo "StartupNotify=true" >> ~/.local/share/applications/DVBVDownloader.desktop
echo "Path="$dest"/dvbviewer/dosdevices/c:/" >> ~/.local/share/applications/DVBVDownloader.desktop
echo "Icon="$dest"/dvbviewer/drive_c/Program Files/DVBViewer/DVBVDownloader.png" >> ~/.local/share/applications/DVBVDownloader.desktop
echo "Categories=AudioVideo;Video;TV"  >> ~/.local/share/applications/DVBVDownloader.desktop
chmod +x ~/.local/share/applications/DVBVDownloader.desktop
#
#keytool
echo "[Desktop Entry]" > ~/.local/share/applications/DVBV-KeyTool.desktop
echo "Name=DVBViewer-KeyTool" >> ~/.local/share/applications/DVBV-KeyTool.desktop
echo "Exec="$dest"/dvbviewer/keytool_start.sh" >> ~/.local/share/applications/DVBV-KeyTool.desktop
echo "Type=Application" >> ~/.local/share/applications/DVBV-KeyTool.desktop
echo "StartupNotify=true" >> ~/.local/share/applications/DVBV-KeyTool.desktop
echo "Path="$dest"/dvbviewer/dosdevices/c:/" >> ~/.local/share/applications/DVBV-KeyTool.desktop
echo "Icon="$dest"/dvbviewer/drive_c/Program Files/DVBViewer/KeyTool.png" >> ~/.local/share/applications/DVBV-KeyTool.desktop
echo "Categories=AudioVideo;Video;TV"  >> ~/.local/share/applications/DVBV-KeyTool.desktop
chmod +x ~/.local/share/applications/DVBV-KeyTool.desktop
#
#
#dvbviewer_run_program
echo "[Desktop Entry]" > ~/.local/share/applications/DVBViewerRunProgram.desktop
echo "Name=DVBViewer Run Program" >> ~/.local/share/applications/DVBViewerRunProgram.desktop
echo "Exec="$dest"/dvbviewer/dvbviewer_run_program.sh" >> ~/.local/share/applications/DVBViewerRunProgram.desktop
echo "Type=Application" >> ~/.local/share/applications/DVBViewerRunProgram.desktop
echo "StartupNotify=true" >> ~/.local/share/applications/DVBViewerRunProgram.desktop
echo "Path="$dest"/dvbviewer/dosdevices/c:/" >> ~/.local/share/applications/DVBViewerRunProgram.desktop
echo "Icon="$dest"/dvbviewer/drive_c/Program Files/DVBViewer/DVBViewer.png" >> ~/.local/share/applications/DVBViewerRunProgram.desktop
echo "Categories=AudioVideo;Video;TV"  >> ~/.local/share/applications/DVBViewerRunProgram.desktop
chmod +x ~/.local/share/applications/DVBViewerRunProgram.desktop
#
#Switch to WindowsXP-----------------------------------------------------------
echo Change dvbviewer prefix to WindowsXP
env WINEARCH=win32 env WINEPREFIX=$dest/dvbviewer $wine_version winecfg /v winxp &>/dev/null
#ready
echo Ready
echo --------------------------------------------------------------------------




