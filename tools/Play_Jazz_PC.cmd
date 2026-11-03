@echo off
setlocal
cd /d "%~dp0.."
if not exist "Binaries\Win32\UDKMobile.exe" (
  echo ERROR: Missing UDKMobile.exe
  pause
  exit /b 2
)
if not exist "MobileGame\Script\JazzPC.u" (
  echo ERROR: Missing compiled JazzPC.u. Compile the controller locally first.
  pause
  exit /b 3
)
if not exist "MobileGame\Content\Maps\JazzMiniGame_PC.mobile" (
  echo ERROR: JazzMiniGame_PC.mobile not found. Keep the original map intact.
  pause
  exit /b 4
)
"Binaries\Win32\UDKMobile.exe" "JazzMiniGame_PC?game=JazzPC.JazzPCGame" -simmobile -windowed -ResX=1024 -ResY=768 -log
