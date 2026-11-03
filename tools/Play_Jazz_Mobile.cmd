@echo off
setlocal
cd /d "%~dp0.."
if not exist "Binaries\Win32\UDKMobile.exe" (
  echo ERROR: Put this tool into the local UDK installation under tools\.
  echo Required: Binaries\Win32\UDKMobile.exe
  pause
  exit /b 2
)
"Binaries\Win32\UDKMobile.exe" JazzMiniGame -simmobile -windowed -ResX=1024 -ResY=768 -log
