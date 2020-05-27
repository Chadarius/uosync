# UOSync

UOSync is a setup of scripts that will sync your Ultima Online config to your cloud drive. This allows you to play on multiple workstations and have your config follow you.

* Backup all of your settings for the UO Client, ClassicUO Client, Razor, and UOAM before you try this script! In fact, I would just backup all of your UO clients, settings, and applications. Don't try this script without a backup. You have been warned!

[Latest Version - v0.1.4 Beta](https://github.com/Chadarius/uosync/archive/latest.zip)

## Features

* Best used with [UO Renaissance Launcher](http://uorenaissance.com/downloads/launcher/UORLauncherSetup.exe) or [UOR PC Package](http://www.uorenaissance.com/downloads/UO_Renaissance_Client_Full.exe) but it can be used with any UO client and or ClassicUO client install. Just make sure you edit the config.cmd to point the uolocaldir variable to the correct location.
* Download and run from any cloud folder. All paths are self-referential.
* UO Client Desktop Sync: The script will sync the original client's Desktop folder which contains all of your account and character configs. Your UO screen setup, macros, and settings will be synchronized to the cloud.
* ClassicUO Client Sync. The script will sync the Data folder to the cloud.
* UOAM Sync: Syncs UOAM files and config. If UOAM is installed at C:\\Program Files\\UOAM it will automatically copy the files to the UOAM folder under your configured Ultima Online local directory (default C:\\UORenaissance\\UOAM). It is also configured to automatically download the [house.txt](http://www.uorenaissance.com/map/house.txt) from the UOR server and create UORHouses.map with every house on the shard. It also imports and exports the settings that UOAM keeps in the registry.
* Backups: Configurable backups of all the files that are synced using the 7zip format. By default it will save the last 15 backups. Every time you launch the script it will make a backup of your UO Client desktop folder ClassicUO Data folder, UOAM .map files, and Razor Macros and Profiles folders. If you mess something up or the scripts mess something up, at least you can grab one of the backups and restore your settings. I've designed the scripts to be as forgiving as possible but sometimes things happen.
* Launches custom applications. Add any applications you want to launch to customapps.cmd along with UO like OBS to record and/or stream, Hex Chat for communications, Discord, or anything else.
* Close custom applications. After you close UOR Launcher you can kill any apps you want (UOAM, Hexchat, OBS, etc...) by adding them to the killapps.cmd.

## Install

1. Download uosync-latest.cmd from the github link to a directory to a synchronized folder for your cloud and unzip it. Example: "%userprofile%\\Google Drive\\uosync".
2. Copy example.config.cmd to config.cmd and make sure you set the uolocaldir variable to where the UO Client/ClassicUO Client is installed. If you don't copy it, it will create a default config.cmd that points to C:\\UORenaissance by default. You need to change this if it is installed elsewhere.
3. Then run uosync.cmd. You can also run uosync.vbs which will run it silently without showing a command prompt. You can create an icon to launch it with the following command line. "c:\\windows\\system32\\wscript.exe /b %userprofile%\\Cloud Drive Path\\uosync\\uosync.vbs"
4. You can run update.ps1 to download the latest script versions. You may need to check the example.config.cmd to see if you need to update your config.cmd with newer settings.