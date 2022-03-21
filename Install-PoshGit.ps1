If (-not(Get-InstalledModule posh-git -ErrorAction silentlycontinue)) {
    Install-Module posh-git -Scope CurrentUser -Confirm:$False -Force; 
    Import-Module posh-git; 
    Add-Content -Value "Import-Module posh-git" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
}
else {
    "posh-git already installed"
}