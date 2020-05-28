
<#
.SYNOPSIS
    Downloads zip archive from Github repository uosync-latest.zip and updates files in the uosync directory
.DESCRIPTION
    Downloads zip archive from Github repository uosync-latest.zip and updates files in the uosync directory
    File Info
 		Filename: update.ps1
		Version: v0.2.0
.EXAMPLE
    GitDownloadZip [GitHub User] [ProjectName] [GitTag]
.EXAMPLE
    GitDownloadZip Chadarius uosync latest
.NOTES
    URL https://github.com/$GitHubUser/$GitProject/archive/$ZipFile
    $GitHubUser = Chadarius
    $GitProject = uosync
    $GitTag = latest
.ROLE
    The role this cmdlet belongs to
.FUNCTIONALITY
    Downloads zip archive from Github repository uosync-latest.zip and updates files in the uosync directory
#>

# Set directory where update.ps1 is running from
$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition

Function GitDownloadZip
{
    Param ($GitHubUser, $GitProject, $GitTag)
    $ZipFile = "$GitTag.zip"
    $UnzipPath = "$ScriptPath\$GitTag\$GitTag-$GitProject"
    $url = "https://github.com/$GitHubUser/$GitProject/archive/$ZipFile"

    Write-Output "Script Path: $ScriptPath"
    Write-Output "GitHub User: $GitHubUser"
    Write-Output "Git Project: $GitProject"
    Write-Output "Git Tag: $GitTag" 
    Write-Output "Unzip Path: $UnzipPath"
    Write-Output "URL: $url"

    # Download file
    Write-Output "Downloading $url to $scriptPath\$ZipFile"
    Invoke-WebRequest -Uri "$url" -OutFile "$scriptPath\$ZipFile"

    # Unzip file
    Write-Output "Unzipping $ScriptPath\$ZipFile"
    Expand-Archive "$ScriptPath\$ZipFile" -Force

    # Move files into correct place
    Write-Output "Move files from $ScriptPath\$GitTag\$GitProject-$GitTag\ to $ScriptPath"
    Move-Item "$ScriptPath\$GitTag\$GitProject-$GitTag\*.*" -Destination "$ScriptPath" -Force

    # Clean up files
    Write-Output "Cleaning up $ScriptPath\$ZipFile"
    Remove-Item "$ScriptPath\$ZipFile" -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Cleaning up $ScriptPath\$GitTag"
    Remove-Item "$ScriptPath\$GitTag" -Recurse -Force -ErrorAction SilentlyContinue
}

GitDownloadZip Chadarius uosync latest
