$ErrorActionPreference = 'Stop'
$toolDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = [System.IO.Path]::GetFullPath((Join-Path $toolDir '..'))
$backupRoot = Join-Path $root '_JazzPCMod\Mouse481Backups'
$lastBackup = Join-Path $backupRoot 'LastBackup_v4_8_1.txt'
if (-not (Test-Path -LiteralPath $lastBackup -PathType Leaf)) { throw 'v4.8.1 backup index not found.' }
$backup = (Get-Content -LiteralPath $lastBackup -TotalCount 1).Trim()
$oldSource = Join-Path $backup 'JazzPCController.uc'
$oldCompiled = Join-Path $backup 'JazzPC.u'
if (-not (Test-Path -LiteralPath $oldSource -PathType Leaf)) { throw 'Backed-up controller source is missing.' }
if (-not (Test-Path -LiteralPath $oldCompiled -PathType Leaf)) { throw 'Backed-up compiled package is missing. Refusing an incomplete restore.' }
if (@(Get-Process -Name 'UDKMobile','UDK' -ErrorAction SilentlyContinue).Count -gt 0) { throw 'Close Jazz and the UDK editor before restoring.' }
Copy-Item -LiteralPath $oldSource -Destination (Join-Path $root 'Development\Src\JazzPC\Classes\JazzPCController.uc') -Force
Copy-Item -LiteralPath $oldCompiled -Destination (Join-Path $root 'MobileGame\Script\JazzPC.u') -Force
Write-Host 'Restored previous controller source and the exact compiled package from the v4.8.1 installation backup.'
