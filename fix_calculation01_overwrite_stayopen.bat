@echo off
setlocal enabledelayedexpansion
REM fix_calculation01_overwrite_stayopen.bat  (ASCII/CRLF)
REM Run INSIDE the target folder for apartment version.
REM It points origin to takumiksk009/calculation01 and overwrites remote main.
REM Window stays open for logs.

echo ===== FIX calculation01 (overwrite) =====
echo Folder: %CD%
echo Time  : %DATE% %TIME%
echo.

git --version >nul 2>&1 || (echo [ERROR] Git not found in PATH & goto END)

REM 0) Mark this directory safe (ownership mismatch workaround)
git config --global --add safe.directory "%CD%" >nul 2>&1

REM 1) Ensure repo and branch
git init
git checkout -B main

REM 2) Set origin to takumiksk009/calculation01 (IMPORTANT)
git remote remove origin 2>nul
git remote add origin https://github.com/takumiksk009/calculation01.git
git remote -v

REM 3) Stage & commit local files (no-op if nothing changed)
git add -A
git commit -m "fix: restore calculation01 content (forced)" || echo (No changes to commit)

REM 4) Refresh info and FORCE push to overwrite remote history
git fetch origin --prune
git push -u --force origin main
set "RC=%ERRORLEVEL%"

echo.
if "%RC%"=="0" (
  echo [OK] Restored: takumiksk009/calculation01 (main)
) else (
  echo [WARN] Push failed. ErrorLevel=%RC%
  echo   - Confirm you are logged in as takumiksk009
  echo   - If no login UI appeared: git config --global credential.helper manager
)

:END
echo.
echo ===== END ===== (window stays open)
echo Press any key to close...
pause >nul
