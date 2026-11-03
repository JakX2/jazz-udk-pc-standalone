@echo off
setlocal EnableExtensions
set "ROOT=%~dp0"
set "EXE=%ROOT%Binaries\Win32\UDKMobile.exe"
set "MAP=%ROOT%MobileGame\Content\Maps\JazzMiniGame.mobile"
if not exist "%EXE%" (
    echo Missing: "%EXE%"
    echo Run Build_Jazz_Portable_v2.cmd from your original UDK folder first.
    pause
    exit /b 1
)
if not exist "%MAP%" (
    echo Missing: "%MAP%"
    pause
    exit /b 1
)
rem Same executable and map arguments that worked in the v3 test.
start "" /D "%ROOT%Binaries\Win32" "%EXE%" JazzMiniGame -simmobile -windowed -ResX=1024 -ResY=768 -log
endlocal