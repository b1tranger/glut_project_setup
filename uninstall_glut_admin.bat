@echo off
:: Self-elevating uninstaller script for Code::Blocks GLUT setup (Legacy & Modern)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

echo ============================================================
echo   Uninstalling Legacy & Current GLUT / FreeGLUT Files
echo ============================================================
echo.

set "SCRIPT_DIR=%~dp0"

:: Change CODEBLOCKS_DIR below if Code::Blocks is installed on another drive or custom path (e.g. D:\CodeBlocks)
set "CODEBLOCKS_DIR=C:\Program Files\CodeBlocks"
set "MINGW=%CODEBLOCKS_DIR%\MinGW"
set "WIZARD_DEST=%CODEBLOCKS_DIR%\share\CodeBlocks\templates\wizard\glut\wizard.script"
set "MAIN_DEST=%CODEBLOCKS_DIR%\share\CodeBlocks\templates\wizard\glut\files\main.cpp"

echo [1/5] Removing GLUT headers from MinGW target include paths...
if exist "%MINGW%\include\GL\glut.h" del /F /Q "%MINGW%\include\GL\glut.h"
if exist "%MINGW%\include\glut.h" del /F /Q "%MINGW%\include\glut.h"
if exist "%MINGW%\x86_64-w64-mingw32\include\GL\glut.h" del /F /Q "%MINGW%\x86_64-w64-mingw32\include\GL\glut.h"
if exist "%MINGW%\x86_64-w64-mingw32\include\glut.h" del /F /Q "%MINGW%\x86_64-w64-mingw32\include\glut.h"

echo [2/5] Removing GLUT static library files (.a) from MinGW lib paths...
if exist "%MINGW%\lib\libfreeglut.a" del /F /Q "%MINGW%\lib\libfreeglut.a"
if exist "%MINGW%\lib\libglut32.a" del /F /Q "%MINGW%\lib\libglut32.a"
if exist "%MINGW%\lib\libglut.a" del /F /Q "%MINGW%\lib\libglut.a"
if exist "%MINGW%\lib\libglut32_x64.a" del /F /Q "%MINGW%\lib\libglut32_x64.a"
if exist "%MINGW%\lib\libglut32_32bit_backup.a" del /F /Q "%MINGW%\lib\libglut32_32bit_backup.a"

if exist "%MINGW%\x86_64-w64-mingw32\lib" (
    if exist "%MINGW%\x86_64-w64-mingw32\lib\libfreeglut.a" del /F /Q "%MINGW%\x86_64-w64-mingw32\lib\libfreeglut.a"
    if exist "%MINGW%\x86_64-w64-mingw32\lib\libglut32.a" del /F /Q "%MINGW%\x86_64-w64-mingw32\lib\libglut32.a"
    if exist "%MINGW%\x86_64-w64-mingw32\lib\libglut.a" del /F /Q "%MINGW%\x86_64-w64-mingw32\lib\libglut.a"
    if exist "%MINGW%\x86_64-w64-mingw32\lib\libglut32_x64.a" del /F /Q "%MINGW%\x86_64-w64-mingw32\lib\libglut32_x64.a"
)

echo [3/5] Removing GLUT DLL files from MinGW bin, System32 & SysWOW64...
if exist "%MINGW%\bin\freeglut.dll" del /F /Q "%MINGW%\bin\freeglut.dll"
if exist "%MINGW%\bin\glut32.dll" del /F /Q "%MINGW%\bin\glut32.dll"
if exist "%MINGW%\bin\glut.dll" del /F /Q "%MINGW%\bin\glut.dll"

if exist "%MINGW%\x86_64-w64-mingw32\bin" (
    if exist "%MINGW%\x86_64-w64-mingw32\bin\freeglut.dll" del /F /Q "%MINGW%\x86_64-w64-mingw32\bin\freeglut.dll"
    if exist "%MINGW%\x86_64-w64-mingw32\bin\glut32.dll" del /F /Q "%MINGW%\x86_64-w64-mingw32\bin\glut32.dll"
    if exist "%MINGW%\x86_64-w64-mingw32\bin\glut.dll" del /F /Q "%MINGW%\x86_64-w64-mingw32\bin\glut.dll"
)

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

echo [4/5] Removing GLUT DLL files from local project output directories (bin\Debug / bin\Release)...
for /r "%SCRIPT_DIR%.." %%d in (bin\Debug bin\Release) do (
    if exist "%%d" (
        if exist "%%d\freeglut.dll" del /F /Q "%%d\freeglut.dll"
        if exist "%%d\glut32.dll" del /F /Q "%%d\glut32.dll"
        if exist "%%d\glut.dll" del /F /Q "%%d\glut.dll"
        echo   - Cleaned project output folder: %%d
    )
)

echo [5/5] Restoring original Code::Blocks GLUT Wizard script & main.cpp template...
if exist "%WIZARD_DEST%.bak" (
    copy /Y "%WIZARD_DEST%.bak" "%WIZARD_DEST%" >nul
    del /F /Q "%WIZARD_DEST%.bak"
    echo   - Restored original wizard script from backup.
)
if exist "%MAIN_DEST%.bak" (
    copy /Y "%MAIN_DEST%.bak" "%MAIN_DEST%" >nul
    del /F /Q "%MAIN_DEST%.bak"
    echo   - Restored original main.cpp template from backup.
)

echo.
echo ============================================================
echo   SUCCESS! All legacy & current GLUT files have been removed.
echo   You can now run install_glut_admin.bat to reinstall cleanly.
echo ============================================================
echo.
pause
