@echo off
setlocal enabledelayedexpansion
REM =====================================================
REM  fresh_push.bat  ::  reset repo and overwrite push
REM  Run this .bat INSIDE the target folder (double-click)
REM  Remote: https://github.com/kokoro3510/calculation01.git
REM  ASCII only / CRLF
REM =====================================================

pushd "%~dp0" || (echo [ERROR] cannot cd to this .bat folder & pause & exit /b 1)
set "REPO=%CD%"
set "REMOTE=https://github.com/kokoro3510/calculation01.git"

echo === reset local .git and start fresh ===

REM 0) mark directory safe
git config --global --add safe.directory "%REPO%" >nul 2>&1

REM 1) remove old .git if exists
if exist "%REPO%\.git" (
  rmdir /s /q "%REPO%\.git"
)

REM 2) init new repo and settings
git init || (echo [ERROR] git init failed & pause & exit /b 1)
git config --local init.defaultBranch main
git config --global credential.helper manager

REM 3) set remote and branch
git remote add origin "%REMOTE%"
git checkout -B main

REM 4) add & commit everything
git add -A
git commit -m "fresh: initial overwrite push" || echo (No changes to commit)

REM 5) push (force-with-lease to overwrite remote)
git push -u --force-with-lease origin main || (
  echo [WARN] push failed. Login may be required or URL/permission invalid.
  git remote -v
  pause
  exit /b 1
)

echo === done ===
git log --oneline -n 3
pause
