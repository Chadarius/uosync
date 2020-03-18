@echo off
::UO Watcher
REM This watches the Razor and UOAM processes to see if they are complete. 
REM  If they are it exports the user registry settings.

set uostorage=%~dp0
set uorazorlocal=%uostorage%Razor
set uolocaldir=C:\UORenaissance
set uoamlocal=%uolocaldir%\UOAM
set PATH=%uostorage%bin;%PATH%

:LOOP1
echo Checking for Razor...
tasklist | c:\windows\system32\find "Razor" >nul 2>&1
IF ERRORLEVEL 1 (
  GOTO CONTINUE1
) ELSE (
  ECHO Razor is still running
  Timeout /T 5 /Nobreak
  cls
  rem pause
  GOTO LOOP1
)

:CONTINUE1
:LOOP2
echo Checking for UORLauncher...
tasklist | c:\windows\system32\find "UORLauncher" >nul 2>&1
IF ERRORLEVEL 1 (
  GOTO CONTINUE2
) ELSE (
   ECHO UOR Launcher is still running
   Timeout /T 5 /Nobreak
   cls
   rem pause
   GOTO LOOP1
)

:CONTINUE2

::Kill any previous robocopy sessions
echo Killing previous robocopy sessions
taskkill /IM robocopy-uoclient.exe /F
taskkill /IM uoam_auto.exe /F
taskkill /IM robocopy-razor.exe /F
taskkill /IM robocopy-uoam.exe /F
::Kill Hexchat
taskkill /IM hexchat.exe /F
taskkill /IM easyuo.exe /F
taskkill /IM openeuo.exe /F
::Export Registry Here
echo Exporting UOAM registry settings
reg export "HKCU\Software\UOAM" "%uoamlocal%\uoam.reg" /y

::Sync up Razor and UOClient Desktop directories to the cloud one last time.
%uostorage%bin\robocopy-uoclient.exe "%uolocaldir%\Desktop" "%uostorage%uoclient\Desktop" /MIR /R:3 /Z /W:1 /MT:100 /LOG:%uostorage%bin\uoclient-config-up.log /TEE /NDL
%uostorage%bin\robocopy-razor.exe "%uolocaldir%\Razor\OSI\Profiles" "%uostorage%Razor\Profiles" /MIR /R:3 /Z /W:1 /MT:100 /LOG:%uostorage%bin\razorprofiles-config-up.log /TEE /NDL
%uostorage%bin\robocopy-razor.exe "%uolocaldir%\Razor\OSI\Macros" "%uostorage%Razor\Macros" /MIR /R:3 /Z /W:1 /MT:100 /LOG:%uostorage%bin\razormacros.log /TEE /NDL
%uostorage%bin\robocopy-uoam.exe "%uolocaldir%\UOAM" "%uostorage%UOAM" /MIR /R:3 /Z /W:1 /MT:100 /LOG:%uostorage%bin\razormacros.log /TEE /NDL


