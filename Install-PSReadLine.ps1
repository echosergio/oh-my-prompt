[CmdletBinding()]
Param()

If (-not(Get-InstalledModule PSReadLine -ErrorAction silentlycontinue)) {
    Install-Module PSReadLine -Scope CurrentUser -Confirm:$False -Force; 
    Import-Module PSReadLine; 
    Add-Content -Value "Import-Module PSReadLine" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
    Add-Content -Value "Set-PSReadLineOption -PredictionSource History" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
    Add-Content -Value "Set-PSReadLineOption -PredictionViewStyle ListView" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
    Add-Content -Value "Set-PSReadLineOption -EditMode Windows" -Encoding utf8 -Path $PROFILE.CurrentUserCurrentHost
}
else {
    "PSReadLine already installed"
}