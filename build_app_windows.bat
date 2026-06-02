@echo off
REM ─────────────────────────────────────────────────────────────────────────────
REM  Cornerstone Mailshot Tool — Windows App Builder
REM  Run this from the folder containing AllInOneTool.py
REM  Output: dist\Cornerstone Mailshot\Cornerstone Mailshot.exe
REM
REM  Usage: Double-click build_app_windows.bat (or run from cmd)
REM ─────────────────────────────────────────────────────────────────────────────

echo ====================================================
echo   Cornerstone Mailshot Tool - Windows Builder
echo ====================================================
echo.

REM Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python not found. Download from python.org
    pause
    exit /b 1
)

echo Step 1: Installing dependencies...
pip install customtkinter requests pillow pyinstaller --quiet
if errorlevel 1 (
    echo ERROR: Failed to install dependencies.
    pause
    exit /b 1
)

echo Step 2: Converting logo to .ico...
python -c "
from PIL import Image
import os
if os.path.exists('logo.png'):
    img = Image.open('logo.png').convert('RGBA')
    bg = Image.new('RGBA', (256,256), (42,42,42,255))
    bg.paste(img, (0,0), img)
    sizes = [(16,16),(32,32),(48,48),(64,64),(128,128),(256,256)]
    bg.save('logo.ico', format='ICO', sizes=sizes)
    print('logo.ico created')
else:
    print('logo.png not found - skipping icon')
"

echo Step 3: Building with PyInstaller...
REM Key flags to reduce AV false positives:
REM   --onedir    instead of --onefile (onefile is more suspicious to AV)
REM   --noupx     disables UPX compression (UPX triggers many AV false positives)
REM   --clean     fresh build each time

set ICON_ARG=
if exist logo.ico set ICON_ARG=--icon=logo.ico

pyinstaller ^
  --noconfirm ^
  --windowed ^
  --onedir ^
  --noupx ^
  --clean ^
  --name "Cornerstone Mailshot" ^
  %ICON_ARG% ^
  --add-data "config.json;." ^
  --add-data "logo.png;." ^
  --hidden-import customtkinter ^
  --hidden-import PIL ^
  --hidden-import PIL.Image ^
  --hidden-import PIL.ImageTk ^
  --collect-all customtkinter ^
  --exclude-module matplotlib ^
  --exclude-module numpy ^
  --exclude-module scipy ^
  --exclude-module pandas ^
  AllInOneTool.py

if errorlevel 1 (
    echo ERROR: Build failed.
    pause
    exit /b 1
)

REM Copy config.json next to the exe so it's easy to edit
if exist config.json (
    copy config.json "dist\Cornerstone Mailshot\config.json" >nul
    echo Copied config.json to dist folder
)
if exist logo.png (
    copy logo.png "dist\Cornerstone Mailshot\logo.png" >nul
)

echo.
echo ====================================================
echo   Build complete!
echo   App folder: dist\Cornerstone Mailshot\
echo   Executable: dist\Cornerstone Mailshot\Cornerstone Mailshot.exe
echo.
echo   IMPORTANT - To reduce Windows security warnings:
echo   1. Zip the entire dist\Cornerstone Mailshot\ folder
echo      before sending to colleagues
echo   2. Tell recipients to right-click the .exe and
echo      choose "Run anyway" if SmartScreen appears
echo   3. For zero warnings: sign with a code certificate
echo      (see README.md for details)
echo ====================================================
pause
