@echo off
setlocal
cd /d "%~dp0"
echo JazzPC v4.7 - compile (this runs the actual UDK compiler, not the old wrapper)
if not exist "Binaries\Win32\UDKMobile.exe" (echo ERROR: Missing UDKMobile.exe & pause & exit /b 2)
if not exist "Development\Src\JazzPC\Classes\JazzPCController.uc" (echo ERROR: Missing controller source & pause & exit /b 2)
if exist "MobileGame\Script\JazzPC.u" (
    echo WARNING: JazzPC.u already exists. If you have not installed v4.7 yet, run the installer first.
)
echo.
cd /d "%~dp0Binaries\Win32"
UDKMobile.exe make -log
set "code=%ERRORLEVEL%"
cd /d "%~dp0"
echo.
echo Compiler exit code: %code%  ^(the compiler may report 0 even on certain failures^)
if exist "MobileGame\Script\JazzPC.u" (
    echo JazzPC.u exists. Confirm the compilation log contains success and launch your PC test map.
) else (
    echo ERROR: JazzPC.u is missing. Do not launch the PC mod.
    echo Restore using Restore_JazzPC_v4_7.cmd if necessary.
)
pause