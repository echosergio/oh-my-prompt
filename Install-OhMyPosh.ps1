[CmdletBinding()]
Param()

Install-WinGetApp -App "JanDeDobbeleer.OhMyPosh" -ErrorAction Stop

if (Test-Path $env:POSH_THEMES_PATH) {
    Copy-Item "$PSScriptRoot\oh-my-posh\themes\custom.omp.json" -Destination $env:POSH_THEMES_PATH -Force
}

$themes = Get-ChildItem -Path "$PSScriptRoot\oh-my-posh\themes" -Recurse "*.json"
foreach ($theme in $themes) {
    Copy-Item $theme.FullName -Destination $env:POSH_THEMES_PATH -Force
}