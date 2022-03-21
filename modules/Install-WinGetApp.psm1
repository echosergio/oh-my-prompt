function Install-WinGetApp {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string]$App,
        [Parameter(Mandatory = $false)]
        [string]$Source
    )

    $listApp = winget list --exact -q $App
    if (![String]::Join("", $listApp).Contains($App)) {
        Write-Host "Installing:" $App
        if ($null -ne $Source) {
            winget install --exact --silent $App --source $Source
        }
        else {
            winget install --exact --silent $App 
        }
    }
    else {
        Write-Host $App "already installed" 
    }
}