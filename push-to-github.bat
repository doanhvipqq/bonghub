@echo off
echo ========================================
echo   BONG X HUB - PUSH TO GITHUB
echo ========================================
echo.

REM Cau hinh Git
echo [1/6] Cau hinh Git user...
git config --global user.name "doanhvipqq"
git config --global user.email "doanh6577765@gmail.com"

REM Khoi tao Git repo
echo [2/6] Khoi tao Git repository...
git init

REM Them remote
echo [3/6] Them remote repository...
git remote remove origin 2>nul
git remote add origin https://github.com/doanhvipqq/bonghub.git

REM Tao file .gitignore
echo [4/6] Tao file .gitignore...
echo # Roblox Script Hub > .gitignore
echo *.log >> .gitignore
echo *.tmp >> .gitignore
echo .vs/ >> .gitignore

REM Tao README.md
echo [5/6] Tao file README.md...
(
echo # ✨ Bóng X Hub - Premium Script Hub
echo.
echo ^<div align="center"^>
echo.
echo ### 👑 Premium Blox Fruits Script Hub
echo.
echo **Developer:** Bóng X - Trần Đức Doanh
echo.
echo **Version:** v3.5 Diamond Edition
echo.
echo **Telegram:** [@doanhvip1](https://t.me/doanhvip1^)
echo.
echo ^</div^>
echo.
echo ---
echo.
echo ## 🚀 Quick Start
echo.
echo ```lua
echo loadstring(game:HttpGet("https://raw.githubusercontent.com/doanhvipqq/bonghub/main/BongX-Hub-Premium.lua"))()
echo ```
echo.
echo ## ✨ Features
echo.
echo - ⚔️ **Auto Farm** - Tự động farm level với nhiều tùy chọn
echo - 📈 **Auto Stats** - Tự động cộng điểm
echo - 🎯 **PVP Tools** - Aimbot, ESP, và nhiều hơn nữa
echo - 🎨 **Visuals** - Full Bright, Remove Fog
echo - 🔧 **Misc** - WalkSpeed, NoClip, Server Hop
echo - 💎 **Premium UI** - Fluent Design với effects đẹp mắt
echo.
echo ## 📋 Tabs
echo.
echo - **📊 Dashboard** - Thông tin user ^& server stats
echo - **⚔️ Auto Farm** - Premium farming features
echo - **📈 Stats ^& Items** - Auto stats system
echo - **🎯 PVP ^& Visuals** - Combat tools
echo - **🎨 Visuals** - Visual effects
echo - **🔧 Misc** - Miscellaneous features
echo - **⚙️ Settings** - Configuration ^& themes
echo.
echo ## 💎 Premium Features
echo.
echo - ✨ **Loading Screen** - Gradient animation
echo - ⚡ **Fast Attack** - Increased attack speed
echo - 🧲 **Bring Mobs** - Pull enemies closer
echo - 👻 **NoClip** - Walk through walls
echo - 🚀 **FPS Boost** - Performance optimization
echo - 💾 **Auto Save** - Automatic config saving
echo.
echo ## 📱 Contact
echo.
echo - **Telegram:** [@doanhvip1](https://t.me/doanhvip1^)
echo - **GitHub:** [doanhvipqq](https://github.com/doanhvipqq^)
echo.
echo ## 📜 License
echo.
echo Copyright © 2026 Bóng X - Trần Đức Doanh. All rights reserved.
echo.
echo ---
echo.
echo ^<div align="center"^>
echo Made with 💎 by Bóng X
echo ^</div^>
) > README.md

REM Add all files
echo [6/6] Pushing to GitHub...
git add .
git commit -m "🚀 Initial commit: Bóng X Hub v3.5 Diamond Edition"
git branch -M main
git push -u origin main --force

echo.
echo ========================================
echo   HOAN THANH!
echo ========================================
echo.
echo Link raw file Premium:
echo https://raw.githubusercontent.com/doanhvipqq/bonghub/main/BongX-Hub-Premium.lua
echo.
echo Link raw file Standard:
echo https://raw.githubusercontent.com/doanhvipqq/bonghub/main/BongX-Hub-Fluent.lua
echo.
pause
