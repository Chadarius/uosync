@echo off
:: uosync.conf
:: Variable settings for uosync.cmd
:: Copy this file to config.cmd and edit the variables 
:: to fit your specific config.
:: %~dp0 is the variable for the directory where this file lives. 
:: It makes this setup portable. I highly suggest you use it for 
:: the uostorage variable.

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
:: Client being used OSI or CUO from UORenaissance Client
:: OSI is the default client. CUO is the newer Open Source client.
:: Directs sync to use specific client directory
set client=OSI
set PATH=%uostorage%bin;%PATH%

echo UO Cloud storage is %uostorage%
echo UO Razor Cloud storage is %uorazorlocal%
echo UO Local install directory is %uolocaldir%
echo UOAM Local install directory is %uoamlocal%
echo UORenaissance Client is %client%

exit /b 0