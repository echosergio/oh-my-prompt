If (-not(Get-InstalledModule posh-git -ErrorAction silentlycontinue)) {
    Install-Module posh-git -Scope CurrentUser -Confirm:$False -Force; Import-Module posh-git; Add-Content -Value "`r`n`r`nImport-Module posh-git`r`n" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
}
else {
    "posh-git already installed"
}