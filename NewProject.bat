@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo.
echo  ntelio_ai -- Project Setup
echo  ------------------------
echo.
echo  This script installs the ntelio_ai development process kit into a project.
echo  The project folder is the parent of the ntelio_ai folder (or symlink).
echo  After a successful install, this script removes the ntelio_ai seed path.
echo.

:: Resolve the project folder as the parent of wherever this .bat lives
set "DOIT_DIR=%~dp0"
:: Remove trailing backslash
if "%DOIT_DIR:~-1%"=="\" set "DOIT_DIR=%DOIT_DIR:~0,-1%"
for %%I in ("%DOIT_DIR%\..") do set "TARGET=%%~fI"
for %%I in ("%TARGET%") do set "PROJECT_NAME=%%~nxI"

echo  Project folder: %TARGET%
echo  Project name:   %PROJECT_NAME%
echo.

:: Check for existing files that should be moved to docs/reference
set "HAS_EXISTING=0"
for %%F in ("%TARGET%\*.*") do (
    if /i not "%%~nxF"==".gitignore" (
    if /i not "%%~nxF"==".gitattributes" (
        set "HAS_EXISTING=1"
    ))
)
set "DO_MOVE=n"
if "%HAS_EXISTING%"=="1" (
    echo  Existing files found in project folder.
    echo  These will be moved to docs\reference\ so they are preserved
    echo  and available to the AI agent as reference material.
    echo.
)
if "%HAS_EXISTING%"=="1" set /p DO_MOVE=Move existing files to docs\reference? [y/n, default y]: 
if "%HAS_EXISTING%"=="1" if not defined DO_MOVE set "DO_MOVE=y"

echo.
echo  -- Optional components --
echo.
echo  Project Stages (PS) adds formal release gates: EVT, DVT, PVT, GA.
echo  Use this for enginering projects, regulated products, or anything
echo  that needs structured milestone reviews with MRD/PRD/ESD documents.
echo.
set /p DO_PS=Include Project Stages? [y/n, default n]: 
if not defined DO_PS set "DO_PS=n"

echo.
echo  Compliance and Governance Review (CGR) adds a structured review
echo  prompt that evaluates your MRD, PRD, and ESD documents against
echo  16 governance rules covering:
echo    - Vendor selection rationale and alternatives
echo    - Supportability, SOPs, and monitoring standards
echo    - Named ownership at each stage gate
echo    - Security review and compliance sign-off
echo    - Rollback plans and go-back conditions
echo    - Pilot requirements before broad rollout
echo    - Operational handoff and support playbooks
echo    - Capacity planning and vendor support agreements
echo    - Post go-live review within 7 days
echo  Use this when you need formal sign-off, audit-readiness, or
echo  stage-gate approval checks. Works with or without PS.
echo.
set /p DO_CGR=Include Governance Review? [y/n, default n]: 
if not defined DO_CGR set "DO_CGR=n"

echo.
set /p DO_GITHUB=Create GitHub repo? [y/n, default n]: 
if not defined DO_GITHUB set "DO_GITHUB=n"

echo.
echo  -- Skills --
echo.
echo  Skills are reusable AI agent workflows installed to .github\skills\.
echo  Default skills included in this kit:
echo    - azure-deploy      : Azure Functions and SWA deployment procedures
echo    - devcycle-management: DT/RDT task lifecycle, retro logging, CU scoring
echo    - project-setup     : ntelio_ai adoption and repo bootstrapping
echo    - powershell-style  : PowerShell scripting conventions
echo    - git-workflow      : Branch strategy, commit format, PR conventions
echo    - example-skill     : Template for creating your own skills
echo.
echo  Options:
echo    1) Install default skills from this kit
echo    2) No skills (you can add them later to .github\skills\)
echo    3) Copy skills from another location
echo.
set /p DO_SKILLS=Choose [1/2/3, default 1]: 
if not defined DO_SKILLS set "DO_SKILLS=1"

set "SKILLS_FLAG="
set "SKILLS_SRC_FLAG="
if "%DO_SKILLS%"=="1" (
    set "SKILLS_FLAG=-IncludeSkills"
) else if "%DO_SKILLS%"=="3" (
    set /p SKILLS_PATH=Path to skills folder: 
)
if "%DO_SKILLS%"=="3" if defined SKILLS_PATH set "SKILLS_SRC_FLAG=-SkillsSource "!SKILLS_PATH!""
if "%DO_SKILLS%"=="3" if not defined SKILLS_PATH echo  No path entered, skipping skills.

set "GITHUB_FLAG="
if /i "%DO_GITHUB%"=="y" set "GITHUB_FLAG=-GitHubRepo "%PROJECT_NAME%""

set "DO_PUBLIC=n"
if /i "%DO_GITHUB%"=="y" (
    echo.
    echo  Public repos are visible to everyone. Private is the default.
    echo.
)
if /i "%DO_GITHUB%"=="y" set /p DO_PUBLIC=Public repo? [y/n, default n]: 
if /i "%DO_GITHUB%"=="y" if not defined DO_PUBLIC set "DO_PUBLIC=n"
if /i "%DO_PUBLIC%"=="y" (
    set "PUBLIC_FLAG=-Public"
) else (
    set "PUBLIC_FLAG="
)

:: Build optional flags
set "PS_FLAG="
if /i "%DO_PS%"=="y" set "PS_FLAG=-IncludePS"

set "CGR_FLAG="
if /i "%DO_CGR%"=="y" set "CGR_FLAG=-IncludeCGR"

:: Move existing files to docs/reference if requested
if /i "%DO_MOVE%"=="y" (
    echo.
    echo  Moving existing files to docs\reference\ ...
    if not exist "%TARGET%\docs\reference" mkdir "%TARGET%\docs\reference"
    for %%F in ("%TARGET%\*.*") do (
        if /i not "%%~nxF"==".gitignore" (
        if /i not "%%~nxF"==".gitattributes" (
            move "%%F" "%TARGET%\docs\reference\" >nul 2>nul
            echo    Moved %%~nxF
        ))
    )
)

echo.
echo  Running ntelio_ai installer ...

if not exist "%DOIT_DIR%\ntelio_ai.ps1" (
    echo  ERROR: ntelio_ai.ps1 not found in %DOIT_DIR%
    echo  The installer script is missing. Re-clone the ntelio_ai kit and try again.
    pause
    exit /b 1
)

:: Find PowerShell -- prefer pwsh (v7+), fall back to powershell (v5)
set "PSCMD="
where pwsh >nul 2>nul && set "PSCMD=pwsh"
if not defined PSCMD where powershell >nul 2>nul && set "PSCMD=powershell"
if not defined PSCMD (
    echo  ERROR: Neither pwsh nor powershell found on PATH.
    echo  Install PowerShell and try again.
    pause
    exit /b 1
)

%PSCMD% -ExecutionPolicy Bypass -File "%DOIT_DIR%\ntelio_ai.ps1" -IncludeScaffold -InitGit -SeedPath "%DOIT_DIR%" -RemoveSeed %PS_FLAG% %CGR_FLAG% %SKILLS_FLAG% %SKILLS_SRC_FLAG% %GITHUB_FLAG% %PUBLIC_FLAG%

if errorlevel 1 (
    echo.
    echo  The installer reported an error. Check the output above.
    pause
    exit /b 1
)

echo.
echo  Done. Project is at %TARGET%
echo  Cleanup scheduled for %DOIT_DIR%
echo  If that path is a symlink or junction, only the link is removed.
echo.
exit /b 0
