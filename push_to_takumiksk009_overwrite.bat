@echo off
setlocal enabledelayedexpansion
REM push_to_takumiksk009_overwrite.bat  (ASCII/CRLF)
REM Run INSIDE the repo folder. Overwrite remote history.

echo ===== OVERWRITE PUSH START =====

git --version >nul 2>&1 || (echo [ERROR] Git not found in PATH & goto END)

REM Mark directory safe (ownership mismatch workaround)
git config --global --add safe.directory "%CD%" >nul 2>&1

git init
git checkout -B main

REM Point remote to takumiksk009
git remote remove origin 2>nul
git remote add origin https://github.com/takumiksk009/calculation01.git
git remote -v

REM Stage & commit
git add -A
git commit -m "overwrite: push local as source of truth" || echo (No changes to commit)

REM Fetch to refresh lease info, then force push
git fetch origin --prune
git push -u --force origin main
set "RC=%ERRORLEVEL%"

echo.
if "%RC%"=="0" (
  echo [OK] Force push completed.
) else (
  echo [WARN] Force push failed. ErrorLevel=%RC%
  echo   - Confirm repo exists and you are logged in as: takumiksk009
)

:END
echo.
echo ===== END ===== (this window stays open)
echo Press any key to close...
pause >nul
