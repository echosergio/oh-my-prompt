[CmdletBinding(SupportsShouldProcess)]
Param(
    [ValidateNotNullOrEmpty()]
    [String]$Path,

    [ValidateSet('System', 'User')]
    [String]$Scope = 'System'
)

Function Get-InstalledFonts {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '')]
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [ValidateSet('System', 'User')]
        [String]$Scope
    )

    switch ($Scope) {
        'System' { $FontsPath = [Environment]::GetFolderPath('Fonts') }
        'User' { $FontsPath = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'Microsoft\Windows\Fonts' }
    }

    Write-Debug -Message ('Enumerating installed {0} fonts ...' -f $Scope.ToLower())
    [IO.FileInfo[]]$Fonts = @()
    try {
        $Fonts += Get-ChildItem -Path $FontsPath -Recurse -ErrorAction Stop | Where-Object Extension -in $ValidExts
    }
    catch {
        $Message = 'Unable to enumerate installed {0} fonts.' -f $Scope.ToLower()
        if ($Scope -eq 'User') {
            Write-Warning -Message $Message
        }
        else {
            throw $Message
        }
    }

    return $Fonts
}

Function Install-Font {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory)]
        [IO.FileInfo[]]$Fonts,

        [Parameter(Mandatory)]
        [ValidateSet('System', 'User')]
        [String]$Scope
    )

    switch ($Scope) {
        'System' {
            $FontsFolder = [Environment]::GetFolderPath('Fonts')
            $FontsRegKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
        }
        'User' {
            $FontsFolder = Join-Path -Path ([Environment]::GetFolderPath('LocalApplicationData')) -ChildPath 'Microsoft\Windows\Fonts'
            $FontsRegKey = 'HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
        }
    }

    if ($Scope -eq 'User') {
        $null = New-Item -Path $FontsFolder -ItemType Directory -ErrorAction Ignore
        $null = New-Item -Path $FontsRegKey -ErrorAction Ignore
    }

    try {
        Add-Type -AssemblyName PresentationCore -ErrorAction Stop
    }
    catch {
        throw $_
    }

    foreach ($Font in $Fonts) {
        $FontInstallName = $Font.Name
        $FontInstallPath = Join-Path -Path $FontsFolder -ChildPath $FontInstallName

        # Matches the convention used by the Explorer shell
        if (Test-Path -Path $FontInstallPath) {
            $FontNameSuffix = -1
            do {
                $FontNameSuffix++
                $FontInstallName = '{0}_{1}{2}' -f $Font.BaseName, $FontNameSuffix, $Font.Extension
                $FontInstallPath = Join-Path -Path $FontsFolder -ChildPath $FontInstallName
            } while (Test-Path -Path $FontInstallPath)
        }
        Write-Debug -Message ('[{0}] Font install path: {1}' -f $Font.Name, $FontInstallPath)

        $FontUri = New-Object -TypeName Uri -ArgumentList $Font.FullName
        try {
            $GlyphTypeface = New-Object -TypeName Windows.Media.GlyphTypeface -ArgumentList $FontUri
        }
        catch {
            Write-Error -Message ('Unable to import font: {0}' -f $Font)
            continue
        }

        $FontNameCulture = 'en-US'
        if ($GlyphTypeface.Win32FamilyNames.ContainsKey($FontNameCulture) -and $GlyphTypeface.Win32FaceNames.ContainsKey($FontNameCulture)) {
            $FontFamilyName = $GlyphTypeface.Win32FamilyNames[$FontNameCulture]
            $FontFaceName = $GlyphTypeface.Win32FaceNames[$FontNameCulture]
        }
        else {
            Write-Error -Message ('Unable to determine font name culture: {0}' -f $Font)
            continue
        }

        # Matches the convention used by the Explorer shell
        if ($FontFaceName -eq 'Regular') {
            $FontRegistryName = '{0} (TrueType)' -f $FontFamilyName
        }
        else {
            $FontRegistryName = '{0} {1} (TrueType)' -f $FontFamilyName, $FontFaceName
        }
        Write-Debug -Message ('[{0}] Font registry name: {1}' -f $Font.Name, $FontRegistryName)

        try {
            $FontsRegItem = Get-Item -Path $FontsRegKey -ErrorAction Stop
        }
        catch {
            throw ('Unable to access {0} fonts registry key.' -f $Scope.ToLower())
        }

        if ($FontsRegItem.Property.Contains($FontRegistryName)) {
            Write-Debug -Message ('Font registry name already exists: {0}' -f $FontRegistryName)
            continue
        }

        Write-Verbose -Message ('Installing font manually: {0}' -f $Font.Name)
        Copy-Item -Path $Font.FullName -Destination $FontInstallPath
        $null = New-ItemProperty -Path $FontsRegKey -Name $FontRegistryName -PropertyType String -Value $FontInstallName
    }
}

Function Test-IsAdministrator {
    [CmdletBinding()]
    [OutputType([Boolean])]
    Param()

    $User = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if ($User.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        return $true
    }
    return $false
}

Function Test-PerUserFontsSupported {
    [CmdletBinding()]
    [OutputType([Boolean])]
    Param()

    # Windows 10 1809 introduced support for installing fonts per-user without Administrator
    # privileges. The corresponding release build number is 17763 (we ignore Insider builds).
    $BuildNumber = [Int](Get-CimInstance -ClassName Win32_OperatingSystem -Verbose:$false).BuildNumber
    if ($BuildNumber -ge 17763) {
        Write-Debug -Message ('Installing fonts per-user is supported (Windows build: {0}).' -f $BuildNumber)
        return $true
    }

    Write-Debug -Message ('Installing fonts per-user is unsupported (Windows build: {0}).' -f $BuildNumber)
    return $false
}

$script:ValidExts = @('.otf', '.ttf')
$script:PerUserFontsSupported = Test-PerUserFontsSupported

if ($Scope -eq 'System') {
    if ($Method -eq 'Shell' -and $PerUserFontsSupported) {
        throw 'Installing fonts system-wide using the Shell API is unsupported on Windows 10 1809 or newer.'
    }
    elseif (!(Test-IsAdministrator)) {
        throw 'Administrator privileges are required to install fonts system-wide.'
    }
}
else {
    if (!$PerUserFontsSupported) {
        throw 'Installing fonts per-user requires Windows 10 1809 or newer.'
    }
}

if (!$PSBoundParameters.ContainsKey('Path')) {
    $Path = $PSScriptRoot
}

try {
    $SourceFontPath = Get-Item -Path $Path -ErrorAction Stop
}
catch {
    throw ('Provided path is invalid: {0}' -f $Path)
}

$SourceFonts = @()
if ($SourceFontPath -is [IO.DirectoryInfo]) {
    $SourceFonts += Get-ChildItem -Path $SourceFontPath -Recurse | Where-Object -Property Extension -in $ValidExts

    if (!$SourceFonts) {
        throw ('Unable to locate any fonts in provided directory: {0}' -f $SourceFontPath)
    }
}
elseif ($SourceFontPath -is [IO.FileInfo]) {
    if ($SourceFontPath.Extension -notin $ValidExts) {
        throw ('Provided file does not appear to be a valid font: {0}' -f $SourceFontPath)
    }

    $SourceFonts += $SourceFontPath
}
else {
    throw ('Expected directory or file but received: {0}' -f $SourceFontPath.GetType().Name)
}

$InstalledFonts = Get-InstalledFonts -Scope $Scope

foreach ($Font in $InstalledFonts) {
    $FileHash = Get-FileHash -Path $Font.FullName
    Add-Member -InputObject $Font -MemberType NoteProperty -Name FileHash -Value $FileHash.Hash
}

$InstallFonts = @()
foreach ($Font in $SourceFonts) {
    $FileHash = Get-FileHash -Path $Font.FullName

    if ($FileHash.Hash -notin $InstalledFonts.FileHash) {
        $InstallFonts += $Font
    }
    else {
        Write-Verbose -Message ('Font is already installed: {0}' -f $Font.Name)
    }
}

Install-Font -Fonts $InstallFonts -Scope $Scope