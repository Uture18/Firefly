@echo off
cd /d C:\Users\50591\Firefly
start /b pnpm dev
echo 博客已启动，正在后台运行...
echo.
echo 按任意键关闭本窗口（程序继续运行）
pause >nul
exit