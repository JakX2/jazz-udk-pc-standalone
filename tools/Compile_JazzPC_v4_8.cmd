@echo off
setlocal
cd /d "%~dp0"
echo JazzPC v4.8 - compiling with the December 2010 mobile runtime
if not exist "Binaries\Win32\UDKMobile.exe" (echo ERROR: UDKMobile.exe not found & pause & exit /b 2)
if not exist "Development\Src\JazzPC\Classes\JazzPCController.uc" (echo ERROR: JazzPC source missing & pause & exit /b 2)
if exist "MobileGame\Script\JazzPC.u" (
  echo ERROR: The compiled package already exists. v4.8 installer should have backed it up and removed it.
  echo Do not overwrite a working build until you have run Install_JazzPC_Mouse_v4_8.cmd.
  pause
  exit /b 3
)
cd /d "%~dp0Binaries\Win32"
UDKMobile.exe make -log > "%~dp0JazzPC_v4_8_Compiler_Output.txt" 2>&1
set "result=%ERRORLEVEL%"
cd /d "%~dp0"
if not exist "MobileGame\Script\JazzPC.u" (
  echo ERROR: JazzPC.u was not generated. Check MobileGame\Logs\Launch.log and JazzPC_v4_8_Compiler_Output.txt.
  echo Run Restore_JazzPC_v4_7.cmd to recover the last working controller.
  pause
  exit /b 4
)
findstr /C:"Error," /C:"Compile aborted" /C:"Failure -" "JazzPC_v4_8_Compiler_Output.txt" >nul
if not errorlevel 1 (
  echo WARNING: Compiler output contains an error. Inspect the log before running Jazz.
  pause
  exit /b 5
)
echo JazzPC.u was created. Confirm Launch.log reports 0 errors, then test the game.
pause
exit /b %result%