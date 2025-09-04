@echo off
setlocal enabledelayedexpansion
REM push_now_calculation01_force.bat  (ASCII/CRLF)
REM Run INSIDE the apartment app folder.

echo ===== PUSH NOW: takumiksk009/calculation01 (force) =====
git --version >nul 2>&1 || (echo [ERROR] Git not found in PATH & goto END)

git config --global --add safe.directory "%CD%" >nul 2>&1

git init
git checkout -B main

REM Force origin to calculation01
git remote remove origin 2>nul
git remote add origin https://github.com/takumiksk009/calculation01.git
echo --- origin set to ---
git remote -v

REM Commit if needed
git add -A
git commit -m "restore: calculation01 content (force)" || echo (No changes to commit)

REM Refresh and FORCE push
git fetch origin --prune
git push -u --force origin main
set "RC=%ERRORLEVEL%"
echo.
if "%RC%"=="0" (
  echo [OK] Done: calculation01 updated.
) else (
  echo [WARN] Push failed. ErrorLevel=%RC%
)
:END
echo Press any key to close...
pause >nul
