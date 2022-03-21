[CmdletBinding()]
Param()

Install-WinGetApp -App "Microsoft.WindowsTerminal" -Source "msstore" -ErrorAction Stop

$fontBlock = @"
    {
        "size": 10,
        "face": "CaskaydiaCove NF"
    }
"@

$pathToSettingsJson = "$($env:USERPROFILE)\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$json = Get-Content $pathToSettingsJson -raw | ConvertFrom-Json
$json.profiles.defaults | Add-Member -Name "font" -Value (Convertfrom-Json $fontBlock) -MemberType NoteProperty -Force
$json | ConvertTo-Json -depth 32 | Set-Content $pathToSettingsJson