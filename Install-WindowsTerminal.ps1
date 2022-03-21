$apps = @(
    @{name = "Microsoft.WindowsTerminal"; source = "msstore" }
);

Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing:" $app.name
        if ($null -ne $app.source) {
            winget install --exact --silent $app.name --source $app.source
        }
        else {
            winget install --exact --silent $app.name 
        }
    }
    else {
        Write-Host $app.name "already installed" 
    }
}

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