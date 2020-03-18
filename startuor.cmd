@echo off
::#######################################################################
:: This script will sync the UO:Renaissance install with a locally sync'd
:: cloud service. Using this script, your UO Client, UOAM, and UORazor 
:: settings will be able to follow you from PC to PC, allowing you to play
:: on your laptop or desktop or multiple desktops with ease.

REM %~dp0 is the location of this batch file. Run it from anywhere 
REM  and it will sync to that location. This should be a folder that
REM  syncs to a cloud service like Google Drive, Box, Dropbox, etc...
REM  You will only need about 250mb of space to sync

:: This is the directory location of the script. Should be in cloud synchronized uo folder
set uostorage=%~dp0
set uorazorlocal=%uostorage%Razor
set uolocaldir=C:\UORenaissance
set uoamlocal=%uolocaldir%\UOAM
set PATH=%uostorage%bin;%PATH%

if not exist "%uolocaldir%" (
	echo No Ultime Online Client installed.
	echo Please install the package from http://uorenaissance.com
	pause
	exit 1
)

::Kill any previous robocopy sessions
echo Killing previous robocopy sessions
tasklist | c:\windows\system32\find "robocopy-razor" >nul 2>&1
IF ERRORLEVEL 1 (
  echo.
) ELSE (
  ECHO Killing Razor
  IF ERRORLEVEL 0 taskkill /IM robocopy-razor.exe /F
)

tasklist | c:\windows\system32\find "robocopy-uoclient" >nul 2>&1
IF ERRORLEVEL 1 (
  echo.
) ELSE (
  ECHO Killing UO Client
  IF ERRORLEVEL 0 taskkill /IM robocopy-uoclient.exe /F
)

tasklist | c:\windows\system32\find "robocopy-uoam" >nul 2>&1
IF ERRORLEVEL 1 (
  echo.
) ELSE (
  ECHO Killing UOAM
  IF ERRORLEVEL 0 taskkill /IM robocopy-uoam.exe /F
)

::Prepare backup directory
echo Checking for "%uostorage%backup"

if not exist "%uostorage%backup" (
	echo Backup directory does not exist. Creating backup directory at "%uostorage%backup"
	mkdir "%uostorage%backup"
)

::Prepare UOAM Directory
::If UOAM folder doesn't exist in %uostorage% grab the files from the UO Renaissance install
::This script runs UOAM from the cloud synchronized folder so that all the data files are used and kept there
if not exist "%uoamlocal%" (
	echo Setting up UOAM
	if exist "C:\Program Files\UOAM" (
		robocopy "C:\Program Files\UOAM" "%uoamlocal%" /MIR /R:3 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\uoam-config-up.log /TEE /NDL"
	)   ELSE (
		echo No UOAM installed. Please install the UO Package from http://uorenaissance.com
		exit 0 
		)
)

::Clean up backup directories save only the last 15 backups
:: Backups just in case of corruption. 

SET Keep=15

::Clean Razor backups
for /f "skip=%Keep% delims=" %%A in ('dir /a:-d /b /o:-d /t:c %uostorage%backup\razor*.7z ^2^>nul') do (
	echo Processing: "%uostorage%backup\%%A"
	if exist "%uostorage%backup\%%A" del "%uostorage%backup\%%A"
)

::Clean UOClient Desktop backups
for /f "skip=%Keep% delims=" %%A in ('dir /a:-d /b /o:-d /t:c %uostorage%backup\uoclientdesktop*.7z ^2^>nul') do (
	echo Processing: "%uostorage%backup\%%A"
	if exist "%uostorage%backup\%%A" del "%uostorage%backup\%%A"
)

::Clean UOAM backups
for /f "skip=%Keep% delims=" %%A in ('dir /a:-d /b /o:-d /t:c %uostorage%backup\uoam*.7z ^2^>nul') do (
	echo Processing: "%uostorage%backup\%%A"
	if exist "%uostorage%backup\%%A" del "%uostorage%backup\%%A"
)

::Sync UOAM from the cloud
echo Sync UOAM from %uostorage%UOAM to %uolocaldir%\UOAM
if not exist "%uostorage%bin\robocopy-uoam.exe" copy c:\windows\system32\robocopy.exe "%uostorage%bin\robocopy-uoam.exe"
robocopy-uoam.exe "c:\users\chada\Google Drive\uo\UOAM" "c:\UORenaissance\UOAM" /MIR /R:3 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\robocopy-uoam.log"

::Sync UORenaissance Houses.txt to UOAM Map file UORHouses.map 
cd "%uoamlocal%"
powershell -ExecutionPolicy Unrestricted -f "%uoamlocal%\UORHousePositions.ps1"
cd "%uostorage%"

::Razor Sync from cloud
echo Syncing UO Razor settings from %uostorage%Razor to %uolocaldir%\Razor
echo.
if not exist "%uostorage%bin\robocopy-razor.exe" copy c:\windows\system32\robocopy.exe "%uostorage%bin\robocopy-razor.exe"

if not exist "%uolocaldir%\Razor\CUO\Profiles" mkdir "%uolocaldir%\Razor\CUO\Profiles"
if not exist "%uolocaldir%\Razor\OSI\Profiles" mkdir "%uolocaldir%\Razor\OSI\Profiles"

if not exist "%uolocaldir%\Razor\CUO\Macros" mkdir "%uolocaldir%\Razor\CUO\Macros"
if not exist "%uolocaldir%\Razor\OSI\Macros" mkdir "%uolocaldir%\Razor\OSI\Macros"

::robocopy-razor.exe "c:\users\chada\Google Drive\uo\Razor\Profiles" "c:\UORenaissance\Razor\CUO\Profiles" /MIR /R:3 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\robocopy-razorprofiles.log"
::robocopy-razor.exe "c:\users\chada\Google Drive\uo\Razor\Macros" "c:\UORenaissance\Razor\CUO\Macros" /MIR /R:3 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\robocopy-razormacros.log"
robocopy-razor.exe "c:\users\chada\Google Drive\uo\Razor\Profiles" "c:\UORenaissance\Razor\OSI\Profiles" /MIR /R:3 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\robocopy-razorprofilesOSI.log"
robocopy-razor.exe "c:\users\chada\Google Drive\uo\Razor\Macros" "c:\UORenaissance\Razor\OSI\Macros" /MIR /R:3 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\robocopy-razormacrosOSI.log"

::Backup lastest Razor config
if exist "%uostorage%Razor" 7za.exe u -r "%uostorage%backup\razor-%DATE:~-4%.%DATE:~4,2%.%DATE:~7,2%.7z" "%uostorage%Razor" 

::UO Client Desktop settings sync cloud
echo Syncing UOClient Desktop settings from %uostorage%uoclient\Desktop to %uolocaldir%\Desktop
echo.
if not exist "%uostorage%bin\robocopy-uoclient.exe" copy c:\windows\system32\robocopy.exe "%uostorage%bin\robocopy-uoclient.exe"

if not exist "%uolocaldir%\Desktop" mkdir "%uolocaldir%\Desktop" 

if exist "%uolocaldir%\Desktop" 7za.exe u -r "%uostorage%backup\uoclientdesktop-%DATE:~-4%.%DATE:~4,2%.%DATE:~7,2%.7z" "%uolocaldir%\Desktop" 

if exist "%uostorage%uoclient\Desktop" "%uostorage%bin\robocopy-uoclient.exe" "%uostorage%uoclient\Desktop" "%uolocaldir%\Desktop" /MIR /R:3 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\uoclient-config-down.log /TEE /NDL"

::Backup UOAM .map files
echo Backing up UOAM .map files
if exist "%uoamlocal%" 7za.exe u -r "%uostorage%backup\uoam-%DATE:~-4%.%DATE:~4,2%.%DATE:~7,2%.7z" "%uoamlocal%\*.map"

::Start Razor and UOAM
echo Starting Razor and UOAM
::if exist "%uoamlocal%\uoam.reg" @powershell start -verb runas reg import "%uoamlocal%\uoam.reg"
if exist "%uoamlocal%\uoam.reg" reg import "%uoamlocal%\uoam.reg"

::start "razor" /D "%uorazorlocal%" "%uorazorlocal%\Razor.exe"
rem Start UO Renaissance Launcher
"C:\Users\chada\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\UO Renaissance\UO Renaissance Launcher.appref-ms"

::Start EasyUO and OpenEUO
::cd %uostorage%easyuo
::@powershell start -verb runas easyuo.exe
::cd %uostorage%openeuo
::@powershell start -verb runas openeuo.exe
::cd %uostorage%

::Start Hexchat IRC - Depricated moved to Discord for UOR - still useful for Twitch however
::echo Starting Hexchat
if exist "%uostorage%HexChatPortable\HexChatPortable.exe" start "Hexchat" /D "%uostorage%HexChatPortable\" "%uostorage%HexChatPortable\HexChatPortable.exe"

::Start up sync for UOClient
echo Starting UOClient Desktop sync up
echo.
start /B "uoclient up sync" %comspec% /S /C ""%uostorage%bin\robocopy-uoclient.exe" "%uolocaldir%\Desktop" "%uostorage%uoclient\Desktop" /MIR /Mon:1 /R:1 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\uoclient-up.log" /TEE /NDL"
start /B "uorazor OSI profiles up sync" %comspec% /S /C ""%uostorage%bin\robocopy-razor.exe" "%uolocaldir%\Razor\OSI\Profiles" "%uostorage%Razor\Profiles" /MIR /Mon:1 /R:1 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\razorprofilesOSI-up.log" /TEE /NDL"
start /B "uorazor OSI macros up sync" %comspec% /S /C ""%uostorage%bin\robocopy-razor.exe" "%uolocaldir%\Razor\OSI\Macros" "%uostorage%Razor\Macros" /MIR /Mon:1 /R:1 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\razormacrosOSI-up.log" /TEE /NDL"
start /B "uoam up sync" %comspec% /S /C ""%uostorage%bin\robocopy-uoam.exe" "%uolocaldir%\UOAM" "%uostorage%UOAM" /MIR /Mon:1 /R:1 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\uoam-up.log" /TEE /NDL"

::Task Process watch here
::start "UOWatch" %comspec% /C "%uostorage%uowatch.cmd"
::start "UOWatch" wscript //B  "%uostorage%uowatch.vbs"
::@powershell start -verb runas wscript //B  "%uostorage%uowatch.vbs"
cd %uostorage%
@powershell start -verb runas "uorwatch.cmd"





