[CmdletBinding()]
Param()

Install-WinGetApp -App "JanDeDobbeleer.OhMyPosh" -ErrorAction Stop

Write-Host "Loading oh-my-posh themes..." 
$env:POSH_THEMES_PATH = [System.Environment]::GetEnvironmentVariable("POSH_THEMES_PATH", "User") 
if (Test-Path $env:POSH_THEMES_PATH) {
    $themes = Get-ChildItem -Path "$PSScriptRoot\oh-my-posh\themes" -Recurse "*.json"
    foreach ($theme in $themes) {
        Copy-Item $theme.FullName -Destination $env:POSH_THEMES_PATH -Force
    }
}