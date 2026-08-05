@echo off
:: Self-elevating installer script for Code::Blocks GLUT setup
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

echo ============================================================
echo   Installing GLUT / FreeGLUT Files & Fixing Code::Blocks Wizard
echo ============================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "SRC=%SCRIPT_DIR%glut_files"
set "MINGW=C:\Program Files\CodeBlocks\MinGW"
set "WIZARD_DEST=C:\Program Files\CodeBlocks\share\CodeBlocks\templates\wizard\glut\wizard.script"

if not exist "%MINGW%\include\GL" mkdir "%MINGW%\include\GL"

echo [1/4] Copying glut.h -> %MINGW%\include\GL...
copy /Y "%SRC%\glut.h" "%MINGW%\include\GL\glut.h"

echo [2/4] Copying 64-bit libglut32.a as libfreeglut.a, libglut32.a, libglut.a...
copy /Y "%SRC%\libglut32_x64.a" "%MINGW%\lib\libfreeglut.a"
copy /Y "%SRC%\libglut32_x64.a" "%MINGW%\lib\libglut32.a"
copy /Y "%SRC%\libglut32_x64.a" "%MINGW%\lib\libglut.a"
copy /Y "%SRC%\libglut32.a" "%MINGW%\lib\libglut32_32bit_backup.a"

echo [3/4] Copying glut32.dll as freeglut.dll, glut32.dll, glut.dll -> %MINGW%\bin...
copy /Y "%SRC%\glut32.dll" "%MINGW%\bin\freeglut.dll"
copy /Y "%SRC%\glut32.dll" "%MINGW%\bin\glut32.dll"
copy /Y "%SRC%\glut32.dll" "%MINGW%\bin\glut.dll"

echo [4/4] Fixing Code::Blocks GLUT Wizard script...
if exist "%SRC%\wizard_fixed.script" (
    copy /Y "%SRC%\wizard_fixed.script" "%WIZARD_DEST%"
)

echo.
echo ============================================================
echo   SUCCESS! GLUT setup & Code::Blocks Wizard fix applied!
echo ============================================================
echo.
pause
