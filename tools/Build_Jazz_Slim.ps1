# Jazz Jackrabbit UDK (2010) - Conservative slim-copy experiment, v1
# Never deletes, edits, or moves source files.
# Copy this script into the working JazzUDK_Portable root before running.
param([string]$Destination = '')

$ErrorActionPreference = 'Stop'
try {
    $Source = (Resolve-Path -LiteralPath $PSScriptRoot).Path
    if ([string]::IsNullOrWhiteSpace($Destination)) {
        $Destination = Join-Path (Split-Path -Parent $Source) 'JazzUDK_Slim_Test'
    }
    $Destination = [System.IO.Path]::GetFullPath($Destination)

    $sourceNorm = $Source.TrimEnd([char]'\')
    $destinationNorm = $Destination.TrimEnd([char]'\')
    if ([string]::Equals($sourceNorm, $destinationNorm, [System.StringComparison]::OrdinalIgnoreCase) -or
        $destinationNorm.StartsWith(($sourceNorm + '\'), [System.StringComparison]::OrdinalIgnoreCase)) {
        throw 'Destination must be outside the existing JazzUDK_Portable folder.'
    }

    $Required = @(
        'Binaries\Win32\UDKMobile.exe',
        'MobileGame\Content\Maps\JazzMiniGame.mobile',
        'MobileGame\Content\Environments\KismetGame_Assets.upk',
        'Engine',
        'UDKGame'
    )
    foreach ($item in $Required) {
        if (-not (Test-Path -LiteralPath (Join-Path $Source $item))) {
            throw "Required source file/folder not found: $item. Place both scripts in your WORKING JazzUDK_Portable root."
        }
    }

    if (Test-Path -LiteralPath $Destination) {
        $existing = @(Get-ChildItem -LiteralPath $Destination -Force)
        if ($existing.Count -gt 0) {
            throw "Destination is not empty: $Destination. Rename or move it first. No files were changed."
        }
    } else {
        New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    }

    $Log = Join-Path $Destination 'Jazz_Slim_Build.log'
    "Jazz UDK slim build v1`r`nSource: $Source`r`nDestination: $Destination`r`nDate: $(Get-Date -Format o)" |
        Set-Content -LiteralPath $Log -Encoding UTF8

    function Copy-Tree {
        param(
            [string]$Relative,
            [string[]]$ExcludeFolders = @(),
            [string[]]$ExcludeFiles = @()
        )
        $from = Join-Path $Source $Relative
        $to   = Join-Path $Destination $Relative
        Write-Host "Copying $Relative ..."
        "`r`nCOPY: $Relative" | Add-Content -LiteralPath $Log
        $argsR = @($from, $to, '/E', '/R:1', '/W:1', '/NP', '/NFL', '/NDL', '/NJH', '/NJS')
        if ($ExcludeFolders.Count -gt 0) {
            $argsR += '/XD'
            foreach ($folder in $ExcludeFolders) {
                $argsR += (Join-Path $from $folder)
            }
        }
        if ($ExcludeFiles.Count -gt 0) {
            $argsR += '/XF'
            $argsR += $ExcludeFiles
        }
        & robocopy.exe @argsR 2>&1 | Out-File -LiteralPath $Log -Append -Encoding UTF8
        $exitCode = $LASTEXITCODE
        "Robocopy exit code: $exitCode" | Add-Content -LiteralPath $Log
        if ($exitCode -ge 8) {
            throw "Copy failed for $Relative (robocopy exit code $exitCode). See $Log"
        }
    }

    Copy-Tree 'Binaries' @('Win64','IPhone','SpeedTreeModeler','ActorX','InstallData')
    Copy-Tree 'Engine'
    Copy-Tree 'MobileGame' @('Autosaves','Logs') @('EpicCitadel.mobile','KismetTutorial_Final.mobile','KismetTutorial_Start.mobile')
    Copy-Tree 'UDKGame' @('Content','Flash','Logs','Movies','Splash')

    foreach ($name in @('Play_Jazz_Portable.cmd','Play_Jazz_Mobile_v3.cmd')) {
        $candidate = Join-Path $Source $name
        if (Test-Path -LiteralPath $candidate) {
            Copy-Item -LiteralPath $candidate -Destination (Join-Path $Destination $name) -ErrorAction Stop
        }
    }

    $play = @'
@echo off
setlocal
cd /d "%~dp0"
if exist "%~dp0Play_Jazz_Portable.cmd" (
    call "%~dp0Play_Jazz_Portable.cmd"
) else (
    if not exist "%~dp0Binaries\Win32\UDKMobile.exe" (
        echo ERROR: Binaries\Win32\UDKMobile.exe not found.
        pause
        exit /b 1
    )
    "%~dp0Binaries\Win32\UDKMobile.exe" JazzMiniGame -simmobile -windowed -ResX=1024 -ResY=768 -log
)
endlocal
'@
    Set-Content -LiteralPath (Join-Path $Destination 'Play_Jazz_Slim.cmd') -Value $play -Encoding ASCII

    foreach ($file in @('Binaries\Win32\UDKMobile.exe',
                       'MobileGame\Content\Maps\JazzMiniGame.mobile',
                       'MobileGame\Content\Environments\KismetGame_Assets.upk')) {
        if (-not (Test-Path -LiteralPath (Join-Path $Destination $file))) {
            throw "Missing essential file after copying: $file"
        }
    }

    $files = @(Get-ChildItem -LiteralPath $Destination -Recurse -File -ErrorAction Stop)
    $bytes = ($files | Measure-Object -Property Length -Sum).Sum
    $mib = [math]::Round($bytes / 1MB, 1)
    Write-Host ''
    Write-Host "SUCCESS: $($files.Count) files, $mib MiB"
    Write-Host "Test: $Destination\Play_Jazz_Slim.cmd"
    "`r`nSUCCESS`r`nFiles: $($files.Count)`r`nBytes: $bytes`r`nMiB: $mib`r`nTest Play_Jazz_Slim.cmd, keep original unchanged." | Add-Content -LiteralPath $Log
}
catch {
    Write-Host ''
    Write-Host ('BUILD FAILED: ' + $_.Exception.Message) -ForegroundColor Red
    if ($Log -and (Test-Path -LiteralPath $Log)) {
        ('ERROR: ' + $_.Exception.ToString()) | Add-Content -LiteralPath $Log
        Write-Host "Log: $Log"
    }
    exit 1
}
