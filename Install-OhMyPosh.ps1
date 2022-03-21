[CmdletBinding()]
Param()

Install-WinGetApp -App "JanDeDobbeleer.OhMyPosh" -ErrorAction Stop

$themes = Get-ChildItem -Path "$PSScriptRoot\oh-my-posh\themes" -Recurse "*.json"
foreach ($theme in $themes) {
    Copy-Item $theme.FullName -Destination $env:POSH_THEMES_PATH -Force
}