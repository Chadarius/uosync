@echo off
::#######################################################################
:: config.cmd
:: Version v0.1.4
:: variable settings for uosync.cmd
::#######################################################################

uosyncver=v0.1.4
:: Sets the directory of the script
:: I create uosync folder in Google Drive
:: and run it from there
set uostorage=%~dp0
:: Location of the UO Renaissance Client directory
set uolocaldir=C:\UORenaissance
:: Location of the cloud razor directory
set uorazorlocal=%uostorage%Razor
:: Location UO Auto Mapper 
set uoamlocal=%uolocaldir%\UOAM
:: Client being used OSI or CUO 
:: Directs sync to use specific client directory
set client=CUO
:: ClassicUO Data directory path
set classicuodir=%uolocaldir%\ClassicUO\Data
set PATH=%uostorage%bin;%PATH%

echo UOSync version is %uosyncver%
echo UO Cloud storage is %uostorage%
echo UO Razor Cloud storage is %uorazorlocal%
echo UO Local install directory is %uolocaldir%
echo UOAM Local install directory is %uoamlocal%
echo UORenaissance Client is %client%
echo ClassicUO Client Data is %classicuodir%

exit /b 0
