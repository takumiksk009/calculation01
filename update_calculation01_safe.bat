@echo off
setlocal enabledelayedexpansion
REM update_calculation01_safe.bat  (ASCII/CRLF)
REM Run INSIDE the apartment app folder.
REM Safe push: keeps history (no force).

echo ===== UPDATE calculation01 (safe) =====
git --version >nul 2>&1 || (echo [ERROR] Git not found in PATH & goto END)

git config --global --add safe.directory "%CD%" >nul 2>&1
git config --global credential.helper manager

git init
git checkout -B main

REM Always point origin to calculation01
git remote remove origin 2>nul
git remote add origin https://github.com/takumiksk009/calculation01.git
echo --- origin ---
git remote -v

REM Try to sync before pushing (ignore if remote empty)
git fetch origin --prune
git merge --ff-only origin/main >nul 2>&1

git add -A
git commit -m "chore: update calculation01" || echo (No changes to commit)

git push -u origin main
set "RC=%ERRORLEVEL%"

echo.
if "%RC%"=="0" (echo [OK] Pushed safely.) else (echo [WARN] Push failed. ErrorLevel=%RC%)
:END
echo Press any key to close...
pause >nul
