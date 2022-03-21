[CmdletBinding()]
Param()

If (-not(Get-InstalledModule Terminal-Icons -ErrorAction silentlycontinue)) {
    Install-Module Terminal-Icons -Scope CurrentUser -Confirm:$False -Force; 
    Import-Module Terminal-Icons; 
    Add-Content -Value "Import-Module Terminal-Icons" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
}
else {
    "Terminal-Icons already installed"
}