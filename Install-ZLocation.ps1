If (-not(Get-InstalledModule ZLocation -ErrorAction silentlycontinue)) {
    Install-Module ZLocation -Scope CurrentUser -Confirm:$False -Force; Import-Module ZLocation; Add-Content -Value "`r`n`r`nImport-Module ZLocation`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
}
else {
    "ZLocation already installed"
}