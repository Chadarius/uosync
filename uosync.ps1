<#
.Synopsis
	This script synchronizes Ultima Online config files to a cloud drive allowing you to sync your UO settings across multiple workstations.
.DESCRIPTION
	This script synchronizes Ultima Online config files to a cloud drive allowing you to sync your UO settings across multiple workstations. It synchronizes UOClassic, UO Client, UOAM, and Razor settings to your cloud drive. In addition it will download the houses.txt file from UO Renaissance and converts it to UOAM and the ClassicUO World Map formats. It will make zip file backups for the synchronized files and save the last 15 by default. It will launch custom apps (HexChat, OBS, etc...) and will also 
	FileInfo
		Filename: uosync.ps1
		Version: v0.2.0
	Todo:
		Logging
		Config File
		Sync function 
			Based on list of folders to sync
		Backup function 
			Based on list of folders to sync
			Number of backups to keep
#>

# Set Variables
# Set directory where script is running from
$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition
$ScriptName = $MyInvocation.MyCommand.Name
$logPath = "$ScriptPath\$ScriptName.log"

Function uosync
{
	Write-log -Message "ScriptPath: $ScriptPath" -Level Info -Path $logPath
	Write-log -Message "ScriptName: $ScriptName" -Level Info -Path $logPath
}

Function SyncFolder
{
	Params($Folder)
}			

# Includes
. $ScriptPath\function-write-log.ps1
	
# Call uosync
uosync 
			
		
