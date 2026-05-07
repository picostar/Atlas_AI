@echo off
setlocal
cd /d "%~dp0"

set "SCRIPT_PATH=%~dp0updateatlas.ps1"
if not exist "%SCRIPT_PATH%" set "SCRIPT_PATH=%~dp0scripts\updateatlas.ps1"

if not exist "%SCRIPT_PATH%" (
    echo.
    echo  ERROR: updateatlas.ps1 was not found in this folder or scripts\.
    echo  Expected one of:
    echo    %~dp0updateatlas.ps1
    echo    %~dp0scripts\updateatlas.ps1
    echo.
    exit /b 1
)

set "PSCMD="
where pwsh >nul 2>nul && set "PSCMD=pwsh"
if not defined PSCMD where powershell >nul 2>nul && set "PSCMD=powershell"

if not defined PSCMD (
    echo.
    echo  ERROR: Neither pwsh nor powershell is available on PATH.
    echo  Install PowerShell and try again.
    echo.
    exit /b 1
)

echo.
echo  Running Atlas updater via %SCRIPT_PATH%
echo.

set "HAS_PROJECTROOT=0"
for %%A in (%*) do (
    if /i "%%~A"=="-ProjectRoot" set "HAS_PROJECTROOT=1"
)

for %%I in ("%~dp0.") do set "SCRIPT_DIR_NAME=%%~nxI"
set "DEFAULT_PROJECT_ROOT="
if "%HAS_PROJECTROOT%"=="0" (
    if /i "%SCRIPT_DIR_NAME%"=="atlas_ai" (
        set "DEFAULT_PROJECT_ROOT=-ProjectRoot .."
    ) else (
        set "DEFAULT_PROJECT_ROOT=-ProjectRoot ."
    )
)

%PSCMD% -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_PATH%" %DEFAULT_PROJECT_ROOT% %*
set "EXITCODE=%ERRORLEVEL%"

if not "%EXITCODE%"=="0" (
    echo.
    echo  Atlas updater failed with exit code %EXITCODE%.
    exit /b %EXITCODE%
)

echo.
echo  Atlas updater finished successfully.
exit /b 0
