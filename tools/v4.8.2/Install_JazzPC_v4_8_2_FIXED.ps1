# JazzPC v4.8.2: Full-source installer; no fragile text replacements.
# Safe to rerun and does NOT modify maps, assets, or compiled JazzPC.u.
$ErrorActionPreference = 'Stop'
try {
    $root = Split-Path -Parent $MyInvocation.MyCommand.Path
    $source = Join-Path $root 'JazzPCController_v4_8_2.uc'
    $target = Join-Path $root 'Development\Src\JazzPC\Classes\JazzPCController.uc'
    $expectedHash = 'e438afba9579e4a0c916fde7477648d0989a238159b77fb119edc38456959265'

    if (-not (Test-Path -LiteralPath (Join-Path $root 'Binaries\Win32\UDKMobile.exe') -PathType Leaf)) {
        throw 'UDKMobile.exe not found. Extract the installer into your full UDK root.'
    }
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw "Corrected source missing: $source" }
    if (-not (Test-Path -LiteralPath $target -PathType Leaf)) { throw "Installed controller missing: $target. No files changed." }
    if (@(Get-Process -Name 'UDK','UDKMobile' -ErrorAction SilentlyContinue).Count -gt 0) {
        throw 'Close Jazz and UDK before modifying the controller.'
    }

    if ((Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expectedHash) {
        throw 'Bundled source checksum mismatch. No files changed.'
    }
    $updated = [System.IO.File]::ReadAllText($source)
    foreach ($required in @('class JazzPCController extends MobilePC',
                            'exec function JazzMouseSimDown(', 'exec function JazzMouseSimUp()',
                            'JazzMovementStrength=120.0', 'screenX=" $ TouchLocation.X',
                            'lastX=" $ JazzMouseScreenPos.X')) {
        if (-not $updated.Contains($required)) { throw "Invalid bundled source; missing $required" }
    }

    $current = [System.IO.File]::ReadAllText($target)
    if (-not $current.Contains('class JazzPCController extends MobilePC') -or -not $current.Contains('JazzMouseSimDown(')) {
        throw 'Expected v4.8.1 mouse controller not present; refusing to overwrite another controller.'
    }
    if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant() -eq $expectedHash) {
        Write-Host 'SUCCESS: Corrected v4.8.2 controller already installed. No changes required.' -ForegroundColor Green
        exit 0
    }

    $backupDir = Join-Path $root ('_JazzPCMod\Mouse482Backups\' + (Get-Date -Format 'yyyyMMdd_HHmmss_fff'))
    New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
    $backupFile = Join-Path $backupDir 'JazzPCController.uc'
    Copy-Item -LiteralPath $target -Destination $backupFile -ErrorAction Stop

    try {
        Copy-Item -LiteralPath $source -Destination $target -Force -ErrorAction Stop
        if ((Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash.ToLowerInvariant() -ne $expectedHash) {
            throw 'Installed source checksum mismatch.'
        }
    } catch {
        Copy-Item -LiteralPath $backupFile -Destination $target -Force -ErrorAction SilentlyContinue
        throw
    }
    Write-Host 'SUCCESS: Full corrected v4.8.2 source installed.' -ForegroundColor Green
    Write-Host "Backup: $backupFile"
    Write-Host 'Compiled JazzPC.u was not modified. Compile separately if needed.'
} catch {
    Write-Host ('FAILED: ' + $_.Exception.Message) -ForegroundColor Red
    exit 1
}