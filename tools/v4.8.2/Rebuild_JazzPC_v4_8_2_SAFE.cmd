@echo off
setlocal EnableExtensions
cd /d "%~dp0"
echo JazzPC v4.8.2 - safe forced recompilation
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Tools\Rebuild_JazzPC_v4_8_2_SAFE.ps1"
set "RC=%ERRORLEVEL%"
echo.
if not "%RC%"=="0" echo Compilation was not verified; see failure and recovery messages above.
pause
exit /b %RC%
