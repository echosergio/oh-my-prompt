[CmdletBinding()]
Param()

Install-WinGetApp -App "JanDeDobbeleer.OhMyPosh" -ErrorAction Stop

if (Test-Path $env:POSH_THEMES_PATH) {
    Copy-Item "$PSScriptRoot\oh-my-posh\themes\custom.omp.json" -Destination $env:POSH_THEMES_PATH -Force
}
