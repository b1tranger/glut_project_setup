@echo off
:: Self-elevating uninstaller script for Code::Blocks GLUT setup (32-Bit & 64-Bit)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

setlocal EnableDelayedExpansion

echo ============================================================
echo   Uninstalling Legacy & Current GLUT / FreeGLUT Files
echo ============================================================
echo.

set "SCRIPT_DIR=%~dp0"

echo Select Code::Blocks Installation to Clean:
echo   [1] C:\Program Files\CodeBlocks
echo   [2] C:\Program Files (x86)\CodeBlocks
echo   [3] All Standard Locations (C:\Program Files & C:\Program Files (x86))
echo   [4] Custom Path / Other Drive (e.g. D:\CodeBlocks)
echo.

set /p CHOICE="Select option [1-4]: "

if "%CHOICE%"=="1" (
    call :CLEAN_DIR "C:\Program Files\CodeBlocks"
) else if "%CHOICE%"=="2" (
    call :CLEAN_DIR "C:\Program Files (x86)\CodeBlocks"
) else if "%CHOICE%"=="3" (
    call :CLEAN_DIR "C:\Program Files\CodeBlocks"
    call :CLEAN_DIR "C:\Program Files (x86)\CodeBlocks"
) else if "%CHOICE%"=="4" (
    set /p CUSTOM_DIR="Enter full path to Code::Blocks directory: "
    if "!CUSTOM_DIR:~-1!"=="\" set "CUSTOM_DIR=!CUSTOM_DIR:~0,-1!"
    call :CLEAN_DIR "!CUSTOM_DIR!"
) else (
    call :CLEAN_DIR "C:\Program Files\CodeBlocks"
    call :CLEAN_DIR "C:\Program Files (x86)\CodeBlocks"
)

echo.
echo Removing GLUT DLL files from System32 & SysWOW64...
if exist "%SystemRoot%\System32" (
    if exist "%SystemRoot%\System32\freeglut.dll" del /F /Q "%SystemRoot%\System32\freeglut.dll"
    if exist "%SystemRoot%\System32\glut32.dll" del /F /Q "%SystemRoot%\System32\glut32.dll"
    if exist "%SystemRoot%\System32\glut.dll" del /F /Q "%SystemRoot%\System32\glut.dll"
)
if exist "%SystemRoot%\SysWOW64" (
    if exist "%SystemRoot%\SysWOW64\freeglut.dll" del /F /Q "%SystemRoot%\SysWOW64\freeglut.dll"
    if exist "%SystemRoot%\SysWOW64\glut32.dll" del /F /Q "%SystemRoot%\SysWOW64\glut32.dll"
    if exist "%SystemRoot%\SysWOW64\glut.dll" del /F /Q "%SystemRoot%\SysWOW64\glut.dll"
)

echo Removing GLUT DLL files from local project output directories (bin\Debug / bin\Release)...
for /r "%SCRIPT_DIR%.." %%d in (bin\Debug bin\Release) do (
    if exist "%%d" (
        if exist "%%d\freeglut.dll" del /F /Q "%%d\freeglut.dll"
        if exist "%%d\glut32.dll" del /F /Q "%%d\glut32.dll"
        if exist "%%d\glut.dll" del /F /Q "%%d\glut.dll"
        echo   - Cleaned project output folder: %%d
    )
)

echo.
echo ============================================================
echo   SUCCESS! All GLUT setup files have been removed.
echo ============================================================
echo.
pause
exit /b 0

:CLEAN_DIR
set "TARGET_DIR=%~1"
set "TARGET_MINGW=%TARGET_DIR%\MinGW"
set "TARGET_WIZARD=%TARGET_DIR%\share\CodeBlocks\templates\wizard\glut\wizard.script"
set "TARGET_MAIN=%TARGET_DIR%\share\CodeBlocks\templates\wizard\glut\files\main.cpp"

if not exist "%TARGET_DIR%" exit /b 0

echo.
echo Cleaning Code::Blocks target: "%TARGET_DIR%"...

if exist "%TARGET_MINGW%\include\GL\glut.h" del /F /Q "%TARGET_MINGW%\include\GL\glut.h"
if exist "%TARGET_MINGW%\include\glut.h" del /F /Q "%TARGET_MINGW%\include\glut.h"

if exist "%TARGET_MINGW%\lib\libfreeglut.a" del /F /Q "%TARGET_MINGW%\lib\libfreeglut.a"
if exist "%TARGET_MINGW%\lib\libglut32.a" del /F /Q "%TARGET_MINGW%\lib\libglut32.a"
if exist "%TARGET_MINGW%\lib\libglut.a" del /F /Q "%TARGET_MINGW%\lib\libglut.a"
if exist "%TARGET_MINGW%\lib\libglut32_x64.a" del /F /Q "%TARGET_MINGW%\lib\libglut32_x64.a"

if exist "%TARGET_MINGW%\bin\freeglut.dll" del /F /Q "%TARGET_MINGW%\bin\freeglut.dll"
if exist "%TARGET_MINGW%\bin\glut32.dll" del /F /Q "%TARGET_MINGW%\bin\glut32.dll"
if exist "%TARGET_MINGW%\bin\glut.dll" del /F /Q "%TARGET_MINGW%\bin\glut.dll"

if exist "%TARGET_WIZARD%.bak" (
    copy /Y "%TARGET_WIZARD%.bak" "%TARGET_WIZARD%" >nul
    del /F /Q "%TARGET_WIZARD%.bak"
    echo   - Restored original wizard script from backup.
)
if exist "%TARGET_MAIN%.bak" (
    copy /Y "%TARGET_MAIN%.bak" "%TARGET_MAIN%" >nul
    del /F /Q "%TARGET_MAIN%.bak"
    echo   - Restored original main.cpp template from backup.
)
exit /b 0

