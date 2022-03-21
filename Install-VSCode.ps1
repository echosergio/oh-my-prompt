[CmdletBinding()]
Param()

Install-WinGetApp -App "Microsoft.VisualStudioCode" -ErrorAction Stop

$pathToSettingsJson = "$($env:APPDATA)\Code\User\settings.json"
$json = Get-Content $pathToSettingsJson -raw | ConvertFrom-Json
$json | Add-Member -Name "terminal.integrated.fontFamily" -Value "CaskaydiaCove NF" -MemberType NoteProperty -Force
$json | Add-Member -Name "terminal.integrated.fontSize" -Value 14 -MemberType NoteProperty -Force
$json | ConvertTo-Json -depth 32 | Set-Content $pathToSettingsJson