@echo off
setlocal
cd /d "%~dp0"

echo ================================================
echo   MVS JSON INVENTORY SIZE APPLIER
echo ================================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0APPLY_INVENTORY_SIZES.ps1"
if errorlevel 1 (
    echo.
    echo FAILED to apply InventorySizes.json.
    pause
    exit /b 1
)

echo.
echo Done. Cargo sizes were written into pack\ModularVestSystem\config.cpp.
echo Rebuild the MVS PBOs before using the changes on the server/client.
pause
