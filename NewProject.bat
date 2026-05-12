@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo.
echo  atlas_ai -- Project Setup
echo  ------------------------
echo.
echo  This script installs the atlas_ai development process kit into a new project.
echo  The project folder is the parent of the atlas_ai folder (or symlink).
echo  Pre-existing user files are preserved under docs\reference\preexisting-root.
echo  If a .git folder already exists, atlas_ai adopts that repository.
echo.

:: Resolve the project folder as the parent of wherever this .bat lives
set "DOIT_DIR=%~dp0"
:: Remove trailing backslash
if "%DOIT_DIR:~-1%"=="\" set "DOIT_DIR=%DOIT_DIR:~0,-1%"
for %%I in ("%DOIT_DIR%\..") do set "TARGET=%%~fI"
for %%I in ("%TARGET%") do set "PROJECT_NAME=%%~nxI"
for %%I in ("%DOIT_DIR%") do set "SEED_NAME=%%~nxI"

echo  Project folder: %TARGET%
echo  Project name:   %PROJECT_NAME%
echo.

echo.
echo  -- Optional components --
echo.
echo  Project Stages (PS) adds formal release gates: EVT, DVT, PVT, GA.
echo  Use this for engineering projects, regulated products, or anything
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

set "GITHUB_OWNER="
if /i "%DO_GITHUB%"=="y" (
    echo.
    echo  Enter your GitHub username or organization name.
    echo  This is the account the repo will be created under.
    echo  Example: myusername  or  my-org
    echo  If not logged in to GitHub CLI, you will be prompted to log in.
    echo.
    set /p GITHUB_OWNER=GitHub account or org: 
    if not defined GITHUB_OWNER (
        echo  GitHub account or org is required for repo creation.
        pause
        exit /b 1
    )
)

echo.
echo  -- Skills --
echo.
echo  Skills are reusable AI agent workflows installed to .github\skills\.
echo  Default skills included in this kit:
echo    - azure-deploy      : Azure Functions and SWA deployment procedures
echo    - devcycle-management: DT/RDT task lifecycle, retro logging, CU scoring
echo    - project-setup     : New project bootstrapping
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

echo.
echo  -- Stack Pattern --
echo.
echo  Choose an initial stack pattern baseline for patterns\stack-patterns\active-stack-pattern.md.
echo  You can change this later by editing stack pattern docs.
echo.
echo  Options:
echo    0) None
echo    1) Functions + Tables + SWA + Key Vault
echo    2) Functions + Tables + SQL Serverless + SWA + Key Vault
echo    3) Functions + Service Bus + Cosmos DB + SWA + Key Vault
echo    4) App Service + Azure SQL + Redis + Front Door + Key Vault
echo.
set /p STACK_PATTERN_CHOICE=Choose [0/1/2/3/4, default 0]: 
if not defined STACK_PATTERN_CHOICE set "STACK_PATTERN_CHOICE=0"

set "STACK_PATTERN_FLAG="
if "%STACK_PATTERN_CHOICE%"=="1" (
    set "STACK_PATTERN_FLAG=-StackPattern sp-01-functions-tables-swa-keyvault.md"
) else if "%STACK_PATTERN_CHOICE%"=="2" (
    set "STACK_PATTERN_FLAG=-StackPattern sp-02-functions-tables-sqlserverless-swa-keyvault.md"
) else if "%STACK_PATTERN_CHOICE%"=="3" (
    set "STACK_PATTERN_FLAG=-StackPattern sp-03-functions-servicebus-cosmos-swa-keyvault.md"
) else if "%STACK_PATTERN_CHOICE%"=="4" (
    set "STACK_PATTERN_FLAG=-StackPattern sp-04-appservice-sql-redis-frontdoor-keyvault.md"
) else if not "%STACK_PATTERN_CHOICE%"=="0" (
    echo  Invalid stack pattern choice, defaulting to none.
)

echo.
echo  -- UX Pattern --
echo.
echo  Choose an initial UX pattern baseline for patterns\ux-patterns\active-ux-pattern.md.
echo  You can change this later by editing UX pattern docs.
echo.
echo  Options:
echo    0) None
echo    1) Modern app shell layout
echo.
set /p UX_PATTERN_CHOICE=Choose [0/1, default 0]: 
if not defined UX_PATTERN_CHOICE set "UX_PATTERN_CHOICE=0"

set "UX_PATTERN_FLAG="
if "%UX_PATTERN_CHOICE%"=="1" (
    set "UX_PATTERN_FLAG=-UxPattern uxp-01-modern-app-shell-layout.md"
) else if not "%UX_PATTERN_CHOICE%"=="0" (
    echo  Invalid UX pattern choice, defaulting to none.
)

echo.
echo  -- API First --
echo.
set "API_FIRST_FLAG="
if "%STACK_PATTERN_CHOICE%"=="0" (
    echo  No stack pattern selected, so no API-first stack posture will be recorded.
) else (
    echo  API-first means each DT should produce an API result when feasible,
    echo  and smoketests should verify API endpoints plus OpenAPI or Swagger docs.
    echo  This posture is recorded in the active stack pattern and enabled by default.
    echo.
    set /p DO_API_FIRST=Enable API-first stack posture? [y/n, default y]:
    if not defined DO_API_FIRST set "DO_API_FIRST=y"
    set "API_FIRST_FLAG=-ApiFirst"
    if /i "!DO_API_FIRST!"=="n" set "API_FIRST_FLAG=-NoApiFirst"
)

set "GITHUB_FLAG="
set "GITHUB_OWNER_FLAG="
if /i "%DO_GITHUB%"=="y" set "GITHUB_FLAG=-GitHubRepo "%PROJECT_NAME%""
if /i "%DO_GITHUB%"=="y" if defined GITHUB_OWNER set "GITHUB_OWNER_FLAG=-GitHubOwner "%GITHUB_OWNER%""

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

echo.
echo  Running atlas_ai installer ...

if not exist "%DOIT_DIR%\atlas_ai.ps1" (
    echo  ERROR: atlas_ai.ps1 not found in %DOIT_DIR%
    echo  The installer script is missing. Re-clone the atlas_ai kit and try again.
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

%PSCMD% -ExecutionPolicy Bypass -File "%DOIT_DIR%\atlas_ai.ps1" -IncludeScaffold %API_FIRST_FLAG% -InitGit %PS_FLAG% %CGR_FLAG% %SKILLS_FLAG% %SKILLS_SRC_FLAG% %STACK_PATTERN_FLAG% %UX_PATTERN_FLAG% %GITHUB_FLAG% %GITHUB_OWNER_FLAG% %PUBLIC_FLAG%

if errorlevel 1 (
    echo.
    echo  The installer reported an error. Check the output above.
    pause
    exit /b 1
)

echo.
echo  Done. Project is at %TARGET%
echo  accounts.md was created for non-secret cloud destination details.
echo  Pre-existing user files were preserved under docs\reference\preexisting-root.
echo  Existing .git metadata was adopted when present.
echo  Temporary atlas_ai source folders used for local bootstrap are cleaned up automatically.
echo  The source folder is bootstrap input only and is not staged or committed.
echo.
exit /b 0
