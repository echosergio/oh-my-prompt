$User = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if (!$User.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw 'Administrator privileges are required.'
}

$InstallWinGet = (Join-Path $PSScriptRoot "Install-WinGet.ps1")
& $InstallWinGet -ErrorAction Stop

$InstallFonts = (Join-Path $PSScriptRoot "Install-Fonts.ps1")
& $InstallFonts -Path "$PSScriptRoot\fonts" -ErrorAction Stop

$InstallWindowsTerminal = (Join-Path $PSScriptRoot "Install-WindowsTerminal.ps1")
& $InstallWindowsTerminal -ErrorAction Stop

$InstallOhMyPosh = (Join-Path $PSScriptRoot "Install-OhMyPosh.ps1")
& $InstallOhMyPosh -ErrorAction Stop

$InstallPoshGit = (Join-Path $PSScriptRoot "Install-PoshGit.ps1")
& $InstallPoshGit -ErrorAction Stop

$InstallPSUtil = (Join-Path $PSScriptRoot "Install-PSUtil.ps1")
& $InstallPSUtil -ErrorAction Stop

$InstallZLocation = (Join-Path $PSScriptRoot "Install-ZLocation.ps1")
& $InstallZLocation -ErrorAction Stop