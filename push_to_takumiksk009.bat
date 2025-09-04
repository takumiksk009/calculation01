@echo off
setlocal enabledelayedexpansion
REM ==============================================
REM  push_to_takumiksk009.bat
REM  Run INSIDE the repo folder. Push to takumiksk009/calculation01
REM  ASCII/CRLF only
REM ==============================================

pushd "%~dp0" || (echo [ERROR] cannot cd to this .bat folder & pause & exit /b 1)
set "REPO=%CD%"
set "REMOTE=https://github.com/takumiksk009/calculation01.git"

git --version >nul 2>&1 || (echo [ERROR] Git not found in PATH & pause & exit /b 1)

REM 1) safe.directory (ownership workaround)
git config --global --add safe.directory "%REPO%" >nul 2>&1

REM 2) init and switch to main
git -C "%REPO%" init
git -C "%REPO%" checkout -B main

REM 3) set remote to takumiksk009
git -C "%REPO%" remote remove origin 2>nul
git -C "%REPO%" remote add origin "%REMOTE%"
git -C "%REPO%" remote -v

REM 4) add -> commit -> push
git -C "%REPO%" add -A
git -C "%REPO%" commit -m "push to takumiksk009/calculation01" || echo (No changes to commit)

REM 5) use Git Credential Manager
git config --global credential.helper manager

git -C "%REPO%" push -u --force-with-lease origin main || (
  echo [WARN] push failed. Check login (account: takumiksk009) and repo existence.
  pause
  exit /b 1
)

echo === done ===
git -C "%REPO%" log --oneline -n 3
pause
