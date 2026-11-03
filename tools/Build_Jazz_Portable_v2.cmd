@echo off
setlocal EnableExtensions EnableDelayedExpansion

rem Jazz Jackrabbit UDK (2010): portable Windows test builder v2
rem Copy-only: DOES NOT delete or change the source game files.
rem Run this script FROM your original UDK installation folder.

set "SOURCE=%~dp0"
set "LOG=%SOURCE%Jazz_Portable_Build_v2.log"
>"%LOG%" echo Jazz UDK portable builder v2 diagnostic log
>>"%LOG%" echo Date: %DATE% %TIME%
>>"%LOG%" echo Script: %~f0
>>"%LOG%" echo Source: %SOURCE%

rem Use the real parent of the script directory, not a silent PowerShell path check.
pushd "%SOURCE%.." 2>>"%LOG%"
if errorlevel 1 (
    echo ERROR: Could not resolve the parent folder of the UDK installation.
    >>"%LOG%" echo ERROR: Failed to resolve parent folder.
    goto :fail
)
set "PARENT=%CD%"
popd
set "DEST=%PARENT%\JazzUDK_Portable"

echo ============================================================
echo  Jazz Jackrabbit UDK 2010 - portable Windows builder v2
echo ============================================================
echo Source: "%SOURCE%"
echo Target: "%DEST%"
echo Log: "%LOG%"
echo.
>>"%LOG%" echo Target: %DEST%

if not exist "%SOURCE%Binaries\Win32\UDKMobile.exe" (
    echo ERROR: UDKMobile.exe missing. Place THIS script in the UDK root.
    >>"%LOG%" echo ERROR: Missing Binaries\Win32\UDKMobile.exe
    goto :fail
)
if not exist "%SOURCE%MobileGame\Content\Maps\JazzMiniGame.mobile" (
    echo ERROR: Missing JazzMiniGame.mobile. Place THIS script in the UDK root.
    >>"%LOG%" echo ERROR: Missing MobileGame\Content\Maps\JazzMiniGame.mobile
    goto :fail
)
if not exist "%SOURCE%MobileGame\Content\Environments\KismetGame_Assets.upk" (
    echo ERROR: Missing KismetGame_Assets.upk.
    >>"%LOG%" echo ERROR: Missing MobileGame\Content\Environments\KismetGame_Assets.upk
    goto :fail
)
if not exist "%SOURCE%Play_Jazz_Portable.cmd" (
    echo ERROR: Play_Jazz_Portable.cmd is missing beside the builder.
    >>"%LOG%" echo ERROR: Missing Play_Jazz_Portable.cmd in source folder.
    goto :fail
)
where robocopy.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: Windows robocopy.exe was not found.
    >>"%LOG%" echo ERROR: robocopy.exe not found.
    goto :fail
)

if not exist "%DEST%\" mkdir "%DEST%" 2>>"%LOG%"
if not exist "%DEST%\" (
    echo ERROR: Could not create destination. Check permissions/disk.
    >>"%LOG%" echo ERROR: Could not create destination.
    goto :fail
)

echo Beginning copy. Existing destination files are kept; no deletions.
echo This may copy several gigabytes.
echo.
>>"%LOG%" echo Starting copy at %DATE% %TIME%
set "FAILED=0"

for %%D in (Binaries Engine MobileGame UDKGame) do (
    if exist "%SOURCE%%%D\" (
        echo --- Copying %%D ---
        >>"%LOG%" echo --- Copying %%D ---
        robocopy "%SOURCE%%%D" "%DEST%\%%D" /E /XJ /R:1 /W:1 /NP /NFL /NDL /TEE /LOG+:"%LOG%"
        set "RC=!ERRORLEVEL!"
        echo robocopy %%D exit code: !RC!
        >>"%LOG%" echo robocopy %%D exit code: !RC!
        if !RC! GEQ 8 (
            echo ERROR: Copy failed for %%D. See log for details.
            >>"%LOG%" echo ERROR: Copy failed for %%D.
            set "FAILED=1"
        )
    ) else (
        echo Skipping %%D ^(not found in source^)
        >>"%LOG%" echo Skipped %%D ^(source missing^)
    )
)

if "!FAILED!"=="1" (
    echo ERROR: One or more folders failed to copy.
    >>"%LOG%" echo ERROR: At least one robocopy job returned 8 or higher.
    goto :fail
)

copy /Y "%SOURCE%Play_Jazz_Portable.cmd" "%DEST%\Play_Jazz_Portable.cmd" >>"%LOG%" 2>&1
if errorlevel 1 (
    echo ERROR: Could not copy Play_Jazz_Portable.cmd.
    >>"%LOG%" echo ERROR: Launcher copy failed.
    goto :fail
)
if exist "%SOURCE%Play_Jazz_Portable_Diagnostic.cmd" (
    copy /Y "%SOURCE%Play_Jazz_Portable_Diagnostic.cmd" "%DEST%\Play_Jazz_Portable_Diagnostic.cmd" >>"%LOG%" 2>&1
)

if not exist "%DEST%\Binaries\Win32\UDKMobile.exe" (
    echo ERROR: Missing UDKMobile.exe after copy.
    >>"%LOG%" echo ERROR: Executable missing after copy.
    goto :fail
)
if not exist "%DEST%\MobileGame\Content\Maps\JazzMiniGame.mobile" (
    echo ERROR: JazzMiniGame.mobile missing after copy.
    >>"%LOG%" echo ERROR: Map missing after copy.
    goto :fail
)
if not exist "%DEST%\MobileGame\Content\Environments\KismetGame_Assets.upk" (
    echo ERROR: KismetGame_Assets.upk missing after copy.
    >>"%LOG%" echo ERROR: Asset package missing after copy.
    goto :fail
)

echo.
echo SUCCESS: Portable test copy created at:
echo "%DEST%"
echo Next: run Play_Jazz_Portable.cmd FROM THAT FOLDER.
echo Note: successful launch here does not prove portability on a clean PC.
>>"%LOG%" echo SUCCESS: Copy and required file checks passed at %DATE% %TIME%
copy /Y "%LOG%" "%DEST%\Jazz_Portable_Build_v2.log" >nul 2>&1
echo.
echo Build log: "%LOG%"
pause
exit /b 0

:fail
echo.
echo FAILED. Your original UDK game files have not been modified.
echo Please send the contents of:
echo "%LOG%"
echo.
>>"%LOG%" echo FAILED at %DATE% %TIME%
pause
exit /b 1