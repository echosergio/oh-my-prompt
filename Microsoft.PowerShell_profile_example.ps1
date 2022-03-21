$User = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if ($User.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
      return;
}

oh-my-posh prompt init pwsh --config "$env:POSH_THEMES_PATH\M365Princess.omp.json" | Invoke-Expression

Import-Module posh-git
Import-Module PSUtil
Import-Module ZLocation
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows
Import-Module Terminal-Icons