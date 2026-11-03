@echo off
setlocal
cd /d "%~dp0"
echo JazzPC v4.8.1 - safe source installation
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Tools\Install_Mouse_v4_8_1.ps1"
set "rc=%ERRORLEVEL%"
if not "%rc%"=="0" echo ERROR: installation failed. Nothing should be compiled until resolved.
pause
exit /b %rc%
