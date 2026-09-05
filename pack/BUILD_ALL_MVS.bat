@echo off
setlocal

rem Builds BOTH PBOs that make up the single @MVS mod.
rem 1) ModularVestSystem.pbo  - original/fixed MVS assets + scripts
rem 2) FreezesMVSArmor.pbo    - JSON-configurable armour companion

set "PACK_ROOT=%~dp0"
set "MVS_SOURCE=%PACK_ROOT%ModularVestSystem"
set "ARMOR_SOURCE=%PACK_ROOT%FreezesMVSArmor"
set "OUTPUT=%PACK_ROOT%output\@MVS\addons"

if defined DAYZ_TOOLS (
    set "ADDON_BUILDER=%DAYZ_TOOLS%\Bin\AddonBuilder\AddonBuilder.exe"
) else (
    set "ADDON_BUILDER=C:\Program Files (x86)\Steam\steamapps\common\DayZ Tools\Bin\AddonBuilder\AddonBuilder.exe"
)

if not exist "%ADDON_BUILDER%" (
    echo ERROR: AddonBuilder.exe was not found.
    echo Set DAYZ_TOOLS to your DayZ Tools installation folder and run this file again.
    echo Example:
    echo   set DAYZ_TOOLS=C:\Program Files (x86)\Steam\steamapps\common\DayZ Tools
    pause
    exit /b 1
)

if not exist "%MVS_SOURCE%\config.cpp" if not exist "%MVS_SOURCE%\config.bin" (
    echo ERROR: Missing MVS config in %MVS_SOURCE%
    pause
    exit /b 1
)

if not exist "%ARMOR_SOURCE%\config.cpp" (
    echo ERROR: Missing JSON armour config in %ARMOR_SOURCE%
    pause
    exit /b 1
)

if not exist "%OUTPUT%" mkdir "%OUTPUT%"

echo.
echo [1/2] Building ModularVestSystem.pbo...
"%ADDON_BUILDER%" "%MVS_SOURCE%" "%OUTPUT%" -prefix=ModularVestSystem -clear
if errorlevel 1 goto :failed

echo.
echo [2/2] Building FreezesMVSArmor.pbo...
"%ADDON_BUILDER%" "%ARMOR_SOURCE%" "%OUTPUT%" -prefix=FreezesMVSArmor -clear -packonly
if errorlevel 1 goto :failed

echo.
echo ========================================
echo BUILD COMPLETE
echo ========================================
echo Final single mod folder:
echo   %PACK_ROOT%output\@MVS
echo.
echo Expected PBOs:
echo   addons\ModularVestSystem.pbo
echo   addons\FreezesMVSArmor.pbo
echo.
echo Put any generated .bikey in @MVS\keys and matching .bisign files beside the PBOs.
pause
exit /b 0

:failed
echo.
echo BUILD FAILED. Check the Addon Builder window/log for the first error.
pause
exit /b 1
