@echo off
cd /d C:/Users/50591/Firefly
echo ==========================================
echo   Push blog update to online (commit + deploy)
echo ==========================================
echo.
git add .
set /p COMMIT_MSG=Enter update note (press Enter = default):
if "%COMMIT_MSG%"=="" set COMMIT_MSG=update
git commit -m "%COMMIT_MSG%"
echo.
echo --- Pushing to GitHub (Cloudflare will auto redeploy) ---
git push
echo.
echo ==========================================
echo   Done! Cloudflare auto-updates in ~2-5 min
echo   Mobile access: https://blog.zqfanxingkeji.online
echo ==========================================
pause
