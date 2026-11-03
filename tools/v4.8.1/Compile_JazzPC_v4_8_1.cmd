@echo off
setlocal EnableExtensions
cd /d "%~dp0"
echo JazzPC v4.8.1 - UnrealScript compilation test
if not exist "Binaries\Win32\UDKMobile.exe" (echo ERROR: missing UDKMobile.exe & pause & exit /b 2)
if not exist "Development\Src\JazzPC\Classes\JazzPCController.uc" (echo ERROR: missing controller & pause & exit /b 2)
if exist "MobileGame\Script\JazzPC.u" (
 echo ERROR: JazzPC.u still exists. Run Install_JazzPC_Mouse_v4_8_1.cmd first.
 pause
 exit /b 3
)
for %%P in (UDKMobile UDK) do (
 tasklist /FI "IMAGENAME eq %%P.exe" /NH 2>nul | find /I "%%P.exe" >nul
 if not errorlevel 1 (
   echo ERROR: Close all UDK or UDKMobile processes before compilation.
   pause
   exit /b 4
 )
)
cd /d "%~dp0Binaries\Win32"
UDKMobile.exe make -log > "%~dp0JazzPC_v4_8_1_Compiler_Output.txt" 2>&1
set "result=%ERRORLEVEL%"
cd /d "%~dp0"
if not exist "MobileGame\Script\JazzPC.u" (
 echo ERROR: JazzPC.u was NOT generated. Read MobileGame\Logs\Launch.log.
 echo Restore with Restore_JazzPC_Pre_v4_8_1.cmd.
 pause
 exit /b 5
)
findstr /I /C:"Compile aborted" /C:"Failure -" /C:"Error, " "JazzPC_v4_8_1_Compiler_Output.txt" >nul
if not errorlevel 1 (
 echo WARNING: compiler output contains errors. Inspect logs and restore your backup.
 pause
 exit /b 6
)
echo JazzPC.u exists. Check MobileGame\Logs\Launch.log for JazzPC and Success - 0 error(s).
echo A generated file does not prove gameplay or mouse support works.
pause
exit /b %result%
