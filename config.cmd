@echo off
:: uosync.conf
:: variable settings for uosync.cmd

:: Sets the directory of the script
:: I create uosync folder in Google Drive
:: and run it from there
set uostorage=%~dp0
:: Location of the cloud razor directory
set uorazorlocal=%uostorage%Razor
:: Location of the UO Renaissance Client directory
set uolocaldir=C:\UORenaissance
:: Location UO Auto Mapper 
set uoamlocal=%uolocaldir%\UOAM
:: Client being used OSI or CUO 
:: Directs sync to use specific client directory
set client=OSI
set PATH=%uostorage%bin;%PATH%

echo UO Cloud storage is %uostorage%
echo UO Razor Cloud storage is %uorazorlocal%
echo UO Local install directory is %uolocaldir%
echo UOAM Local install directory is %uoamlocal%
echo UORenaissance Client is %client%

exit /b 0