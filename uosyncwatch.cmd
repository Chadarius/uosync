@echo off
:: uosyncwat.cmd
:: Version v0.1.4
:: This watches the Razor and UORLauncher processes.
:: When they are no longer running it kills processes from the killapps.cmd,
:: shuts down background sync, and
:: syncs configuration data to the cloud drive one last time.

echo --------------------------------------------------------------------
echo Watching Razor and UORLauncher. 
echo This script will cleanup, sync, and exit 
echo when those programs are no longer running
echo See "%~dp0uosyncwatch.log" for errors or status
echo --------------------------------------------------------------------
echo.

call :main >"%~dp0uosyncwatch.log"
exit /b

:main
call "%~dp0config.cmd"

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
taskkill /IM robocopy-classicuo.exe /F

:: Kill any custom apps you want to close when UO closes.
if not exist "%uostorage%killapps.cmd" copy "%uostorage%example.killapps.cmd" "%uostorage%killapps.cmd"
call "%uostorage%killapps.cmd"

::Sync up Razor and UOClient Desktop directories to the cloud one last time.
echo Final sync to cloud drive
%uostorage%bin\robocopy-uoclient.exe "%uolocaldir%\Desktop" "%uostorage%uoclient\Desktop" /MIR /R:3 /Z /W:1 /MT:100
%uostorage%bin\robocopy-razor.exe "%uolocaldir%\Razor\%client%\Profiles" "%uostorage%Razor\Profiles" /MIR /R:3 /Z /W:1 /MT:100
%uostorage%bin\robocopy-razor.exe "%uolocaldir%\Razor\%client%\Macros" "%uostorage%Razor\Macros" /MIR /R:3 /Z /W:1 /MT:100
%uostorage%bin\robocopy-uoam.exe "%uoamlocal%" "%uostorage%UOAM" /MIR /R:3 /Z /W:1 /MT:100 
%uostorage%bin\robocopy-classicuo.exe "%classicuodir%" "%uostorage%classicuo" /MIR /R:3 /Z /W:1 /MT:100 

::Export Registry Here
echo Exporting UOAM registry settings
del /q "%uostorage%UOAM\uoam.reg"
reg export "HKCU\Software\UOAM" "%uostorage%UOAM\uoam.reg" /y

