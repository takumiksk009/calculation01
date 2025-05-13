@echo off
cd /d "C:\Users\KSK\Desktop\LINE WORKSアプリ\アパート版計算アプリ"

echo === GitHub 初期設定と上書き push ===

git init
git remote remove origin
git remote add origin https://github.com/takumiksk009/calculation01.git
git branch -M main

echo --- ファイル追加 & コミット ---
git add .
git commit -m "Initial overwrite push to calculation01"

echo --- GitHub に強制 push ---
git push -f origin main

echo === 完了！GitHub を確認してね ===
pause