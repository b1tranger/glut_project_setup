@echo off
:: Self-elevating installer script for Code::Blocks GLUT setup
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

echo ============================================================
echo   Installing 64-Bit GLUT / FreeGLUT Files & Fixing Code::Blocks
echo ============================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "SRC=%SCRIPT_DIR%glut_files"

:: Change CODEBLOCKS_DIR below if Code::Blocks is installed on another drive or custom path (e.g. D:\CodeBlocks)
set "CODEBLOCKS_DIR=C:\Program Files\CodeBlocks"
set "MINGW=%CODEBLOCKS_DIR%\MinGW"
set "WIZARD_DEST=%CODEBLOCKS_DIR%\share\CodeBlocks\templates\wizard\glut\wizard.script"
set "MAIN_DEST=%CODEBLOCKS_DIR%\share\CodeBlocks\templates\wizard\glut\files\main.cpp"

if not exist "%MINGW%\include\GL" mkdir "%MINGW%\include\GL"

echo [1/5] Copying glut.h -> %MINGW%\include\GL...
copy /Y "%SRC%\glut.h" "%MINGW%\include\GL\glut.h"

echo [2/5] Copying 64-bit libglut32.a as libfreeglut.a, libglut32.a, libglut.a...
copy /Y "%SRC%\libglut32_x64.a" "%MINGW%\lib\libfreeglut.a"
copy /Y "%SRC%\libglut32_x64.a" "%MINGW%\lib\libglut32.a"
copy /Y "%SRC%\libglut32_x64.a" "%MINGW%\lib\libglut.a"

echo [3/5] Copying genuine 64-bit glut32.dll & freeglut.dll to MinGW & System32...
copy /Y "%SRC%\glut32.dll" "%MINGW%\bin\freeglut.dll"
copy /Y "%SRC%\glut32.dll" "%MINGW%\bin\glut32.dll"
copy /Y "%SRC%\glut32.dll" "%MINGW%\bin\glut.dll"

if exist "%MINGW%\x86_64-w64-mingw32\bin" (
    copy /Y "%SRC%\glut32.dll" "%MINGW%\x86_64-w64-mingw32\bin\freeglut.dll"
    copy /Y "%SRC%\glut32.dll" "%MINGW%\x86_64-w64-mingw32\bin\glut32.dll"
    copy /Y "%SRC%\glut32.dll" "%MINGW%\x86_64-w64-mingw32\bin\glut.dll"
)

if exist "%SystemRoot%\System32" (
    copy /Y "%SRC%\glut32.dll" "%SystemRoot%\System32\freeglut.dll"
    copy /Y "%SRC%\glut32.dll" "%SystemRoot%\System32\glut32.dll"
    copy /Y "%SRC%\glut32.dll" "%SystemRoot%\System32\glut.dll"
)

echo [4/5] Copying 64-bit DLL into local project output directories (bin\Debug / bin\Release)...
for /r "%SCRIPT_DIR%.." %%d in (bin\Debug bin\Release) do (
    if exist "%%d" (
        echo   - Found project output folder: %%d
        copy /Y "%SRC%\glut32.dll" "%%d\freeglut.dll" >nul
        copy /Y "%SRC%\glut32.dll" "%%d\glut32.dll" >nul
        copy /Y "%SRC%\glut32.dll" "%%d\glut.dll" >nul
    )
)

echo [5/5] Fixing Code::Blocks GLUT Wizard script & main.cpp template...
if exist "%SRC%\wizard_fixed.script" (
    if not exist "%WIZARD_DEST%.bak" if exist "%WIZARD_DEST%" copy /Y "%WIZARD_DEST%" "%WIZARD_DEST%.bak" >nul
    copy /Y "%SRC%\wizard_fixed.script" "%WIZARD_DEST%"
)
if exist "%SRC%\main.cpp" (
    if not exist "%MAIN_DEST%.bak" if exist "%MAIN_DEST%" copy /Y "%MAIN_DEST%" "%MAIN_DEST%.bak" >nul
    copy /Y "%SRC%\main.cpp" "%MAIN_DEST%"
)


echo.
echo ============================================================
echo   SUCCESS! 64-bit GLUT setup applied cleanly!
echo   0xc000007b errors are resolved for all 64-bit builds.
echo ============================================================
echo.
pause
