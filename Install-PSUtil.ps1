[CmdletBinding()]
Param()

If (-not(Get-InstalledModule PSUtil -ErrorAction silentlycontinue)) {
    Install-Module PSUtil -Scope CurrentUser -Confirm:$False -Force; 
    Import-Module PSUtil; 
    Add-Content -Value "Import-Module PSUtil" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
}
else {
    "PSUtil already installed"
}