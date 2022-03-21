If (-not(Get-InstalledModule PSUtil -ErrorAction silentlycontinue)) {
    Install-Module PSUtil -Scope CurrentUser -Confirm:$False -Force; Import-Module PSUtil; Add-Content -Value "`r`n`r`nImport-Module PSUtil`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
}
else {
    "PSUtil already installed"
}