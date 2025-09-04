@echo off
setlocal enabledelayedexpansion
REM ASCII only. Run INSIDE the target repo folder.

pushd "%~dp0" || (echo [ERROR] cannot cd to this .bat folder & pause & exit /b 1)
set "REPO=%CD%"
set "REMOTE=https://github.com/kokoro3510/calculation01.git"

git --version >nul 2>&1 || (echo [ERROR] Git not found in PATH & pause & exit /b 1)

REM 0) Mark this folder safe (Windows ownership mismatch workaround)
git config --global --add safe.directory "%REPO%"

REM 1) Ensure Windows Git Credential Manager is used
git config --global credential.helper manager

REM 2) Clear cached creds for github.com so login UI will appear
set "_TMP_=__gcm_tmp__.txt"
> "%_TMP_%" echo protocol=https
>>"%_TMP_%" echo host=github.com
git credential-manager-core erase < "%_TMP_%" >nul 2>&1
del "%_TMP_%" >nul 2>&1

REM 3) Init/remote/branch
git -C "%REPO%" init
git -C "%REPO%" remote remove origin 2>nul
git -C "%REPO%" remote add origin "%REMOTE%"
git -C "%REPO%" checkout -B main

REM 4) Quick auth check (this should pop login UI)
echo Checking access to GitHub (login may be required)...
git -C "%REPO%" ls-remote --heads origin || (
  echo [WARN] Authentication failed or repo not found. Ensure account "kokoro3510" owns "calculation01".
  pause
  exit /b 1
)

REM 5) Add/commit/push
git -C "%REPO%" add -A
git -C "%REPO%" commit -m "auto: update (login helper)" || echo (No changes to commit)
git -C "%REPO%" push -u --force-with-lease origin main || (
  echo [WARN] push failed. Please confirm repo URL and account permissions.
  git -C "%REPO%" remote -v
  pause
  exit /b 1
)

git -C "%REPO%" log --oneline -n 3
echo Done.
pause
