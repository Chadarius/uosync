<# 
    File name = update.ps1
    uosyncver=v0.1.4
    Downloads zip archive from Github repository
    uosync-latest.zip and updates files in the uosync directory
#>

<# GitHub Info
 URL https://github.com/$GitHubUser/$GitProject/archive/$ZipFile
$GitHubUser = Chadarius
$GitProject = uosync
$GitTag = latest
#>

<# Call GitDownloadZip function
    Example: GitHubUser GitProject GitTag 
    GitDownloadZip GitHubUser GitProject GitTag
#>

# Set directory where update.ps1 is running from
$ScriptPath = split-path -parent $MyInvocation.MyCommand.Definition

GitDownloadZip Chadarius uosync latest

Function GitDownloadZip{
    Param ($GitHubUser, $GitProject, $GitTag)
    $ZipFile = "$GitTag.zip"
    $UnzipPath = "$ScriptPath\$GitTag\$GitTag-$GitProject"
    $url = "https://github.com/$GitHubUser/$GitProject/archive/$ZipFile"

    write "Script Path: $ScriptPath"
    write "GitHub User: $GitHubUser"
    write "Git Project: $GitProject"
    write "Git Tag: $GitTag" 
    write "Unzip Path: $UnzipPath"
    write "URL: $url"

    # Download file
    write "Downloading $url to $scriptPath\$ZipFile"
    Invoke-WebRequest -Uri "$url" -OutFile "$scriptPath\$ZipFile"

    # Unzip file
    write "Unzipping $ScriptPath\$ZipFile"
    Expand-Archive "$ScriptPath\$ZipFile" -Force

    # Move files into correct place
    write "Move files from $ScriptPath\$GitTag\$GitProject-$GitTag\ to $ScriptPath"
    Move-Item "$ScriptPath\$GitTag\$GitProject-$GitTag\*.*" -Destination "$ScriptPath" -Force

    # Clean up files
    write "Cleaning up $ScriptPath\$ZipFile"
    Remove-Item "$ScriptPath\$ZipFile" -Recurse -Force -ErrorAction SilentlyContinue
    write "Cleaning up $ScriptPath\$GitTag"
    Remove-Item "$ScriptPath\$GitTag" -Recurse -Force -ErrorAction SilentlyContinue
}
