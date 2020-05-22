@echo off
::#######################################################################
:: This script will sync the UO:Renaissance install with a locally sync'd
:: cloud service. Using this script, your UO Client, UOAM, and UORazor 
:: settings will be able to follow you from PC to PC, allowing you to play
:: on your laptop or desktop or multiple desktops with ease.
:: 
:: This will backup your existing Razo, UOAM, and UO Client configs
:: to the backup folder using 7zip. Drop 7z.exe in the bin folder.
echo --------------------------------------------------------------------
echo UOSync is running
echo See "%~dp0uosync.log" for status and errors
echo --------------------------------------------------------------------

echo.

call :main >"%~dp0uosync.log"
exit /b

:main
if not exist "%~dp0config.cmd" copy "%~dp0example.config.cmd" "%~dp0config.cmd"
call "%~dp0config.cmd"

if not exist "%uolocaldir%" (
	echo No Ultime Online Client installed.
	echo Please install the package from http://uorenaissance.com
	exit /B 1
)

::Kill any previous robocopy sessions
echo Killing previous robocopy sessions
tasklist | c:\windows\system32\find "robocopy-razor" >nul 2>&1
IF ERRORLEVEL 1 (
  echo.
) ELSE (
  ECHO Killing Razor Sync
  IF ERRORLEVEL 0 taskkill /IM robocopy-razor.exe /F
)

tasklist | c:\windows\system32\find "robocopy-uoclient" >nul 2>&1
IF ERRORLEVEL 1 (
  echo.
) ELSE (
  ECHO Killing UO Client Sync
  IF ERRORLEVEL 0 taskkill /IM robocopy-uoclient.exe /F
)

tasklist | c:\windows\system32\find "robocopy-uoam" >nul 2>&1
IF ERRORLEVEL 1 (
  echo.
) ELSE (
  ECHO Killing UOAM Sync
  IF ERRORLEVEL 0 taskkill /IM robocopy-uoam.exe /F
)

tasklist | c:\windows\system32\find "robocopy-classicuo" >nul 2>&1
IF ERRORLEVEL 1 (
  echo.
) ELSE (
  ECHO Killing ClassicUO Sync
  IF ERRORLEVEL 0 taskkill /IM robocopy-classicuo.exe /F
)

::Prepare backup directory
echo Checking for "%uostorage%backup"
if not exist "%uostorage%backup" (
	echo Backup directory does not exist. Creating backup directory at "%uostorage%backup"
	mkdir "%uostorage%backup"
) ELSE (
	echo OK
)

::Prepare bin directory
echo Checking for "%uostorage%bin"
if not exist "%uostorage%bin" (
	echo Bin directory does not exist. Creating backup directory at "%uostorage%bin"
	mkdir "%uostorage%bin"
) ELSE (
	echo OK
)

:: Checking for 7za.exe utility used for backups
echo Check for %uostorage%bin\7za.exe utility used for backups
if not exist "%uostorage%bin\7za.exe" (
	echo %uostorage%bin\7za.exe missing
	echo Please install from https://www.7-zip.org/download.html and copy 7za.exe to %uostorage%bin
	exit /B 1
) ELSE (
	echo OK
)

::Prepare UOAM Directory
::If UOAM folder doesn't exist in %uostorage% grab the files from the UO Renaissance install
::This script runs UOAM from the cloud synchronized folder so that all the data files are used and kept there
if not exist "%uoamlocal%" (
	echo Setting up UOAM
	if exist "C:\Program Files\UOAM" (
		robocopy "C:\Program Files\UOAM" "%uoamlocal%" /MIR /R:3 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\uoam-config-up.log /TEE /NDL"
	)   ELSE (
		echo No UOAM installed. Please install the UOR Package from http://uorenaissance.com
		exit /b 1 
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

::Clean ClassicUOData backups
for /f "skip=%Keep% delims=" %%A in ('dir /a:-d /b /o:-d /t:c %uostorage%backup\classicuo*.7z ^2^>nul') do (
	echo Processing: "%uostorage%backup\%%A"
	if exist "%uostorage%backup\%%A" del "%uostorage%backup\%%A"
)

::Sync UORenaissance Houses.txt to UOAM Map file UORHouses.map 
echo.
echo UO Local Directory is %uoamlocal%"
cd "%uostorage%UOAM"
powershell -ExecutionPolicy Unrestricted -f "%uoamlocal%\UORHousePositions.ps1"
cd "%uostorage%"

::Sync UOAM from the cloud
echo Sync UOAM from %uostorage%UOAM to %uolocaldir%\UOAM
if not exist "%uostorage%bin\robocopy-uoam.exe" copy c:\windows\system32\robocopy.exe "%uostorage%bin\robocopy-uoam.exe"
if exist "%uostorage%UOAM" robocopy-uoam.exe "%uostorage%UOAM" "%uoamlocal%" /MIR /R:3 /Z /W:1 /MT:100 /LOG:"%uostorage%bin\robocopy-uoam.log"

::Razor Sync from cloud
echo Syncing UO Razor settings from %uostorage%Razor to %uolocaldir%\Razor\%client%
echo.
if not exist "%uostorage%bin\robocopy-razor.exe" copy c:\windows\system32\robocopy.exe "%uostorage%bin\robocopy-razor.exe"
::if not exist "%uolocaldir%\Razor\%client%\Profiles" mkdir "%uolocaldir%\Razor\%client%\Profiles"
::if not exist "%uolocaldir%\Razor\%client%\Macros" mkdir "%uolocaldir%\Razor\%client%\Macros"
if exist "%uolocaldir%\Razor\%client%\Profiles" robocopy-razor.exe "%uostorage%Razor\Profiles" "%uolocaldir%\Razor\%client%\Profiles" /MIR /R:3 /Z /W:1 /MT:100
if exist "%uolocaldir%\Razor\%client%\Macros" robocopy-razor.exe "%uostorage%Razor\Macros" "%uolocaldir%\Razor\%client%\Macros" /MIR /R:3 /Z /W:1 /MT:100

::Backup lastest Razor config
echo Backing up Razor config 
if exist "%uostorage%Razor" 7za.exe u -r "%uostorage%backup\razor-%DATE:~-4%.%DATE:~4,2%.%DATE:~7,2%.7z" "%uostorage%Razor" ^2^>nul

::ClassicUO Sync from cloud
echo Syncing ClassicUO settings from %uostorage%classicuo to %classicuodir%
echo.
if not exist "%uostorage%bin\robocopy-classicuo.exe" copy c:\windows\system32\robocopy.exe "%uostorage%bin\robocopy-classicuo.exe"
if exist "%uostorage%classicuo" robocopy-razor.exe "%uostorage%classicuo" "%classicuodir%" /MIR /R:3 /Z /W:1 /MT:100

::Backup lastest ClassicUO config
echo Backing up ClassicUO config 
if exist "%uostorage%classicuo" 7za.exe u -r "%uostorage%backup\classicuo-%DATE:~-4%.%DATE:~4,2%.%DATE:~7,2%.7z" "%uostorage%classicuo" ^2^>nul

::UO Client Desktop settings sync cloud
echo Syncing UOClient Desktop settings from %uostorage%uoclient\Desktop to %uolocaldir%\Desktop
if not exist "%uostorage%bin\robocopy-uoclient.exe" copy c:\windows\system32\robocopy.exe "%uostorage%bin\robocopy-uoclient.exe"
if not exist "%uolocaldir%\Desktop" mkdir "%uolocaldir%\Desktop" 
if exist "%uostorage%Desktop" 7za.exe u -r "%uostorage%backup\uoclientdesktop-%DATE:~-4%.%DATE:~4,2%.%DATE:~7,2%.7z" "%uolocaldir%\Desktop" ^2^>nul
robocopy-uoclient.exe "%uostorage%uoclient\Desktop" "%uolocaldir%\Desktop" /MIR /R:3 /Z /W:1 /MT:100

::Backup UOAM .map files
echo Backing up UOAM .map files
if exist "%uoamlocal%" 7za.exe u -r "%uostorage%backup\uoam-%DATE:~-4%.%DATE:~4,2%.%DATE:~7,2%.7z" "%uoamlocal%\*.map" ^2^>nul

::Start Razor and UOAM
echo Starting Razor and UOAM
Echo Importing UOAM registry settings 
if exist "%uoamlocal%\uoam.reg" reg import "%uoamlocal%\uoam.reg"

::start "razor" /D "%uorazorlocal%" "%uorazorlocal%\Razor.exe"
rem Start UO Renaissance Launcher
"%appdata%\Microsoft\Windows\Start Menu\Programs\UO Renaissance\UO Renaissance Launcher.appref-ms"

::Start Custom Apps 
:: If customapps.cmd doesn't exist yet copy example.customapps.cmd and use that
if not exist "%uostorage%customapps.cmd" copy "%uostorage%example.customapps.cmd" "%uostorage%customapps.cmd"
call "%uostorage%customapps.cmd"

::Start up sync for UOClient
echo Starting UOClient Desktop sync up
echo.
echo Syncing "%uolocaldir%\Desktop" to "%uostorage%uoclient\Desktop"
start /B "uoclient up sync" %comspec% /S /C ""%uostorage%bin\robocopy-uoclient.exe" "%uolocaldir%\Desktop" "%uostorage%uoclient\Desktop" /MIR /Mon:1 /R:1 /Z /W:1 /MT:100"
echo Syncing "%uolocaldir%\Razor\%client%\Profiles" to "%uostorage%Razor\Profiles"
start /B "uorazor profiles up sync" %comspec% /S /C ""%uostorage%bin\robocopy-razor.exe" "%uolocaldir%\Razor\%client%\Profiles" "%uostorage%Razor\Profiles" /MIR /Mon:1 /R:1 /Z /W:1 /MT:100"
echo Syncing "%uolocaldir%\Razor\%client%\Macros" to "%uostorage%Razor\Macros"
start /B "uorazor macros up sync" %comspec% /S /C ""%uostorage%bin\robocopy-razor.exe" "%uolocaldir%\Razor\%client%\Macros" "%uostorage%Razor\Macros" /MIR /Mon:1 /R:1 /Z /W:1 /MT:100"
echo Syncing "%uolocaldir%\UOAM" "%uostorage%UOAM"
start /B "uoam up sync" %comspec% /S /C ""%uostorage%bin\robocopy-uoam.exe" "%uoamlocal%" "%uostorage%UOAM" /MIR /Mon:1 /R:1 /Z /W:1 /MT:100"
echo Syncing "%classicuodir%" "%uostorage%classicuo"
start /B "classicuo up sync" %comspec% /S /C ""%uostorage%bin\robocopy-classicuo.exe" "%classicuodir%" "%uostorage%classicuo" /MIR /Mon:1 /R:1 /Z /W:1 /MT:100"

cd %uostorage%
@powershell -ExecutionPolicy Unrestricted start -verb runas "uosyncwatch.cmd"




