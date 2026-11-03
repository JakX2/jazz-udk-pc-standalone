@echo off
setlocal
cd /d "%~dp0"
echo JazzPC v4.8.1 - restore exact pre-test source and compiled package
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Tools\Restore_Mouse_v4_8_1.ps1"
set "rc=%ERRORLEVEL%"
pause
exit /b %rc%
