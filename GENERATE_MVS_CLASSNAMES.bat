@echo off
setlocal
cd /d "%~dp0"
echo ================================================
echo   MVS COMPLETE CLASSNAME LIST GENERATOR
echo ================================================
echo.
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0GENERATE_MVS_CLASSNAMES.ps1"
if errorlevel 1 (
    echo.
    echo FAILED to generate classname list.
    pause
    exit /b 1
)
echo.
echo Done. Open MVS_CLASSNAMES.txt in this folder.
pause
