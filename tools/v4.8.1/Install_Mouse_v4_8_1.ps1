$ErrorActionPreference = 'Stop'
$toolDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = [System.IO.Path]::GetFullPath((Join-Path $toolDir '..'))
$src = Join-Path $root 'Development\Src\JazzPC\Classes\JazzPCController.uc'
$replacement = Join-Path $root 'Source\JazzPCController_v4_8_1.uc'
$compiled = Join-Path $root 'MobileGame\Script\JazzPC.u'
$exe = Join-Path $root 'Binaries\Win32\UDKMobile.exe'
$backupRoot = Join-Path $root '_JazzPCMod\Mouse481Backups'
$lastBackup = Join-Path $backupRoot 'LastBackup_v4_8_1.txt'
foreach ($path in @($src, $replacement, $exe)) {
  if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw ('Required file missing: ' + $path) }
}
$running = @(Get-Process -Name 'UDKMobile','UDK' -ErrorAction SilentlyContinue)
if ($running.Count -gt 0) { throw 'Close Jazz and the UDK editor before installing.' }
$content = [System.IO.File]::ReadAllText($src)
if ($content.Contains('exec function JazzMouseSimDown(')) {
  Write-Host 'v4.8.1 source already installed. No changes made.'
  exit 0
}
if (-not $content.Contains('JazzMovementStrength=120.0') -or -not $content.Contains('function PulseMobileLook(') -or -not $content.Contains('JazzSetMoveStrength')) {
  throw 'Expected v4.7/v4.8-compatible controller not found. Refusing to overwrite an unknown source.'
}
$newSource = [System.IO.File]::ReadAllText($replacement)
foreach ($needle in @('function JazzOnPCInputTouch(', 'exec function JazzMouseSimDown(', 'exec function JazzMouseSimUp()', 'JazzMovementStrength=120.0', 'exec function JazzMouseStatus()')) {
  if (-not $newSource.Contains($needle)) { throw ('Incomplete v4.8.1 source, missing: ' + $needle) }
}
$backup = Join-Path $backupRoot (Get-Date -Format 'yyyyMMdd_HHmmss_fff')
New-Item -ItemType Directory -Path $backup -Force | Out-Null
Copy-Item -LiteralPath $src -Destination (Join-Path $backup 'JazzPCController.uc') -ErrorAction Stop
$hasOldPackage = Test-Path -LiteralPath $compiled -PathType Leaf
if ($hasOldPackage) { Copy-Item -LiteralPath $compiled -Destination (Join-Path $backup 'JazzPC.u') -ErrorAction Stop }
try {
  Copy-Item -LiteralPath $replacement -Destination $src -Force -ErrorAction Stop
  if ($hasOldPackage) { Remove-Item -LiteralPath $compiled -Force -ErrorAction Stop }
  Set-Content -LiteralPath $lastBackup -Value $backup -Encoding ASCII
  Write-Host ('Installed JazzPC v4.8.1 source. Backup: ' + $backup)
  Write-Host 'JazzPC.u has been backed up and removed to force the compiler to rebuild it.'
  Write-Host 'Next: Compile_JazzPC_v4_8_1.cmd'
} catch {
  Copy-Item -LiteralPath (Join-Path $backup 'JazzPCController.uc') -Destination $src -Force -ErrorAction SilentlyContinue
  if ($hasOldPackage) { Copy-Item -LiteralPath (Join-Path $backup 'JazzPC.u') -Destination $compiled -Force -ErrorAction SilentlyContinue }
  throw
}
