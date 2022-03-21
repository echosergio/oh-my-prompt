$User = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (!$User.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Administrator privileges are required.'
}

$modules = Get-ChildItem -Path $PsModulesPath -Recurse "*.psm1"
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

$InstallWindowsTerminal = (Join-Path $PSScriptRoot "Install-WindowsTerminal.ps1")
& $InstallWindowsTerminal -ErrorAction Stop

$InstallVSCode = (Join-Path $PSScriptRoot "Install-VSCode.ps1")
& $InstallVSCode -ErrorAction Stop

$InstallOhMyPosh = (Join-Path $PSScriptRoot "Install-OhMyPosh.ps1")
& $InstallOhMyPosh -ErrorAction Stop

$InstallPoshGit = (Join-Path $PSScriptRoot "Install-PoshGit.ps1")
& $InstallPoshGit -ErrorAction Stop

$InstallPSUtil = (Join-Path $PSScriptRoot "Install-PSUtil.ps1")
& $InstallPSUtil -ErrorAction Stop

$InstallZLocation = (Join-Path $PSScriptRoot "Install-ZLocation.ps1")
& $InstallZLocation -ErrorAction Stop

$InstallPSReadLine = (Join-Path $PSScriptRoot "Install-PSReadLine.ps1")
& $InstallPSReadLine -ErrorAction Stop

$InstallTerminalIcons = (Join-Path $PSScriptRoot "Install-TerminalIcons.ps1")
& $InstallTerminalIcons -ErrorAction Stop