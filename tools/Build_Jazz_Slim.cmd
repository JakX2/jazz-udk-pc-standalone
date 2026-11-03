@echo off
setlocal
chcp 65001 >nul
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Build_Jazz_Slim.ps1"
set "ERR=%ERRORLEVEL%"
echo.
if not "%ERR%"=="0" (
    echo Slim build failed. See the on-screen error or build log.
) else (
    echo Slim test build finished. Try Play_Jazz_Slim.cmd in the new folder.
)
pause
exit /b %ERR%