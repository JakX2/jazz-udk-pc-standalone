# Safe v4.8.2 forced rebuild. Copy to UDK_ROOT\Tools\, run root CMD.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$source = Join-Path $root 'Development\Src\JazzPC\Classes\JazzPCController.uc'
$pkg = Join-Path $root 'MobileGame\Script\JazzPC.u'
$exe = Join-Path $root 'Binaries\Win32\UDKMobile.exe'
$logs = Join-Path $root 'MobileGame\Logs'
$expected = 'e438afba9579e4a0c916fde7477648d0989a238159b77fb119edc38456959265'
$backup = $null
$hadOld = $false
$removed = $false
try {
    if (-not (Test-Path -LiteralPath $exe -PathType Leaf)) { throw 'UDKMobile.exe is missing. Extract to the full UDK root.' }
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw 'JazzPC source is missing.' }
    $hash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($hash -ne $expected) { throw 'The installed controller is not the verified v4.8.2 source. Run the fixed source installer first; no files modified.' }
    if (@(Get-Process -Name UDK,UDKMobile -ErrorAction SilentlyContinue).Count -gt 0) {
        throw 'Close Jazz/UDK editor and other UDKMobile processes before compiling.'
    }
    $backup = Join-Path $root ('_JazzPCMod\Mouse482BuildBackups\' + (Get-Date -Format 'yyyyMMdd_HHmmss_fff'))
    New-Item -ItemType Directory -Path $backup -Force | Out-Null
    $out = Join-Path $backup 'Compiler_stdout.txt'
    $err = Join-Path $backup 'Compiler_stderr.txt'
    $report = Join-Path $backup 'Rebuild_Report.txt'
    Copy-Item -LiteralPath $source -Destination (Join-Path $backup 'JazzPCController_v4_8_2.uc')
    $hadOld = Test-Path -LiteralPath $pkg -PathType Leaf
    if ($hadOld) {
        $prev = Join-Path $backup 'JazzPC_previous.u'
        Copy-Item -LiteralPath $pkg -Destination $prev -ErrorAction Stop
        if ((Get-FileHash -LiteralPath $pkg).Hash -ne (Get-FileHash -LiteralPath $prev).Hash) {
            throw 'Backup checksum mismatch; nothing removed.'
        }
        Remove-Item -LiteralPath $pkg -Force -ErrorAction Stop
        $removed = $true
        Write-Host 'Backed up the previous JazzPC.u and removed only the compiled mod package.'
    }
    $start = Get-Date
    Write-Host 'Running UDKMobile.exe make (no -log window)...'
    $proc = Start-Process -FilePath $exe -ArgumentList @('make') -WorkingDirectory (Split-Path -Parent $exe) -RedirectStandardOutput $out -RedirectStandardError $err -PassThru
    if (-not $proc.WaitForExit(120000)) {
        try { $proc.Kill() } catch {}
        throw 'Compiler did not exit normally. The previous compiled package will be restored.'
    }
    $proc.WaitForExit()
    $code = $proc.ExitCode
    $text = ''
    foreach ($file in @($out,$err)) {
        if (Test-Path -LiteralPath $file) { $text += [IO.File]::ReadAllText($file) + [Environment]::NewLine }
    }
    $recent = $null
    if (Test-Path -LiteralPath $logs -PathType Container) {
        $recent = Get-ChildItem -LiteralPath $logs -Filter '*.log' -File -ErrorAction SilentlyContinue |
          Where-Object { $_.LastWriteTime -ge $start.AddSeconds(-2) -and $_.Length -gt 0 } |
          Sort-Object LastWriteTime -Descending | Select-Object -First 1
    }
    if ($null -ne $recent) { $text += [Environment]::NewLine + [IO.File]::ReadAllText($recent.FullName) }
    $fresh = Get-Item -LiteralPath $pkg -ErrorAction SilentlyContinue
    $errorFound = $text -match '(?im)Compile aborted|Failure\s*-\s*[1-9]|\b[1-9][0-9]* error\(s\)|\bError, '
    $successFound = ($text -match '(?im)Success\s*-\s*0 error\(s\)') -or
      (($text -match '(?im)JazzPC\s*-\s*Release') -and ($text -match '(?im)Scripts successfully compiled\s*-\s*saving package'))
    $summary = "Exit code: $code; compiled file present: $($null -ne $fresh); errors: $errorFound; success marker: $successFound"
    Set-Content -LiteralPath $report -Value $summary -Encoding UTF8
    if ($code -ne 0 -or $null -eq $fresh -or $fresh.Length -le 0 -or $errorFound -or -not $successFound) {
        throw ('Compilation not positively verified. ' + $summary)
    }
    Write-Host 'SUCCESS: v4.8.2 JazzPC.u rebuilt; test the separate PC map.' -ForegroundColor Green
    Write-Host ('Previous package backup: ' + $backup)
    exit 0
}
catch {
    Write-Host ('FAILED: ' + $_.Exception.Message) -ForegroundColor Red
    if ($removed -and $hadOld -and $null -ne $backup) {
        try {
            if (Test-Path -LiteralPath $pkg) { Remove-Item -LiteralPath $pkg -Force -ErrorAction Stop }
            Copy-Item -LiteralPath (Join-Path $backup 'JazzPC_previous.u') -Destination $pkg -Force -ErrorAction Stop
            Write-Host 'RESTORED previous JazzPC.u automatically.' -ForegroundColor Yellow
        } catch {
            Write-Host ('Automatic restore failed: ' + $_.Exception.Message) -ForegroundColor Red
            Write-Host ('Recover JazzPC_previous.u manually from ' + $backup)
        }
    }
    if ($null -ne $backup) { Write-Host ('Compiler diagnostics and backups: ' + $backup) }
    exit 1
}