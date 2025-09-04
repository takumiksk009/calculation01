@echo off
setlocal enabledelayedexpansion
REM keep-open push script (ASCII/CRLF). Run INSIDE the target folder.

echo ===== PUSH START =====
echo Script: %~nx0
echo Folder: %CD%
echo Time  : %DATE% %TIME%
echo.

REM 0) ensure Git exists
git --version >nul 2>&1 || (
  echo [ERROR] Git not found in PATH.
  echo Install Git for Windows or open "Git CMD".
  goto :END
)

REM 1) mark directory safe
git config --global --add safe.directory "%CD%" >nul 2>&1

REM 2) init & switch to main
git init
git checkout -B main

REM 3) set remote to takumiksk009
git remote remove origin 2>NUL
git remote add origin https://github.com/takumiksk009/calculation01.git
git remote -v

REM 4) add & commit
git add -A
git commit -m "push to takumiksk009/calculation01 (keep-open)" || echo (No changes to commit)

REM 5) push (force-with-lease)
git push -u --force-with-lease origin main
set "RC=%ERRORLEVEL%"
echo.
if "%RC%"=="0" (
  echo [OK] Push completed.
) else (
  echo [WARN] Push failed. ErrorLevel=%RC%
  echo   - Check login (account: takumiksk009)
  echo   - If no login window appeared: git config --global credential.helper manager
)

:END
echo.
echo ===== END =====  (this window stays open)
echo Press any key to close...
pause >nul
