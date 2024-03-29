$User = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (!$User.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Administrator privileges are required.'
}

Write-Host "Updating PackageManagement..." 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; 
Install-Module -Name PackageManagement -Force -MinimumVersion 1.4.6 -Scope CurrentUser -AllowClobber -Repository PSGallery

$modules = Get-ChildItem -Path "$PSScriptRoot\modules" -Recurse "*.psm1"
$i = 0
foreach ($module in $modules) {
    $i++
    Write-Progress -Activity "Importing modules" -Status "$module" -PercentComplete ($i / $modules.Count * 100) 
    Import-Module -Force $module.FullName -DisableNameChecking;
}
Write-Progress -Activity "Importing modules" -Completed

$InstallWinGet = (Join-Path $PSScriptRoot "Install-WinGet.ps1")
& $InstallWinGet -ErrorAction Stop

Install-Fonts -Path "$PSScriptRoot\fonts" -ErrorAction Stop

Write-Host "Installing Windows Terminal..." 
$InstallWindowsTerminal = (Join-Path $PSScriptRoot "Install-WindowsTerminal.ps1")
& $InstallWindowsTerminal -ErrorAction Stop

Write-Host "Installing VSCode..." 
$InstallVSCode = (Join-Path $PSScriptRoot "Install-VSCode.ps1")
& $InstallVSCode -ErrorAction Stop

Write-Host "Installing OhMyPosh..." 
$InstallOhMyPosh = (Join-Path $PSScriptRoot "Install-OhMyPosh.ps1")
& $InstallOhMyPosh -ErrorAction Stop

Write-Host "Installing PoshGit..." 
$InstallPoshGit = (Join-Path $PSScriptRoot "Install-PoshGit.ps1")
& $InstallPoshGit -ErrorAction Stop

Write-Host "Installing PSUtil..." 
$InstallPSUtil = (Join-Path $PSScriptRoot "Install-PSUtil.ps1")
& $InstallPSUtil -ErrorAction Stop

Write-Host "Installing ZLocation..." 
$InstallZLocation = (Join-Path $PSScriptRoot "Install-ZLocation.ps1")
& $InstallZLocation -ErrorAction Stop

Write-Host "Installing PSReadLine..." 
$InstallPSReadLine = (Join-Path $PSScriptRoot "Install-PSReadLine.ps1")
& $InstallPSReadLine -ErrorAction Stop

Write-Host "Installing Terminal-Icons..." 
$InstallTerminalIcons = (Join-Path $PSScriptRoot "Install-TerminalIcons.ps1")
& $InstallTerminalIcons -ErrorAction Stop