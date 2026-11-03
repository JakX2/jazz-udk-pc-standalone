@echo off
setlocal
cd /d "%~dp0"
echo JazzPC v4.8.2 - full-source installer, not a text patch
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install_JazzPC_v4_8_2_FIXED.ps1"
set "rc=%ERRORLEVEL%"
if not "%rc%"=="0" echo Installation failed. No compilation attempted.
echo.
pause
exit /b %rc%