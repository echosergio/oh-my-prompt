$apps = @(
    @{name = "JanDeDobbeleer.OhMyPosh" }
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

if (Test-Path $env:POSH_THEMES_PATH) {
    Copy-Item "$PSScriptRoot\oh-my-posh\themes\custom.omp.json" -Destination $env:POSH_THEMES_PATH -Force
}
