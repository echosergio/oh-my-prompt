[CmdletBinding()]
Param()

If (-not(Get-InstalledModule ZLocation -ErrorAction silentlycontinue)) {
    Install-Module ZLocation -Scope CurrentUser -Confirm:$False -Force; 
    Import-Module ZLocation; 
    Add-Content -Value "Import-Module ZLocation" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
}
else {
    "ZLocation already installed"
}