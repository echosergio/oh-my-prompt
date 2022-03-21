$User = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if ($User.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
      return;
}

oh-my-posh prompt init pwsh --config "$env:POSH_THEMES_PATH\hunk.omp.json" | Invoke-Expression

Import-Module posh-git
Import-Module PSUtil
Import-Module ZLocation