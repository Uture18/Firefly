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
if errorlevel 1 echo [note] Nothing new to commit - continuing to push.

echo.
echo --- Pushing to GitHub (Cloudflare will auto redeploy) ---
git push

if errorlevel 1 goto PUSHFAILED

echo.
echo ==========================================
echo   SUCCESS - Cloudflare updates in ~2-5 min
echo   Mobile access: https://blog.zqfanxingkeji.online
echo ==========================================
goto END

:PUSHFAILED
echo.
echo ********************************************************
echo   PUSH FAILED - YOUR SITE WAS ***NOT*** UPDATED!
echo   Copy the error lines above and send them to the AI.
echo   If it says 'no upstream branch', run this once:
echo       git push --set-upstream origin master
echo ********************************************************

:END
pause
