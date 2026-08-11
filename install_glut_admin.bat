@echo off
:: Self-elevating installer script for Code::Blocks GLUT setup (32-Bit & 64-Bit)
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb RunAs"
    exit /b
)

setlocal EnableDelayedExpansion

echo ============================================================
echo   Installing GLUT / FreeGLUT Setup for Code::Blocks
echo   Supports: 32-Bit (v17+) ^& 64-Bit (v20+) Installations
echo ============================================================
echo.

set "SCRIPT_DIR=%~dp0"
set "SRC=%SCRIPT_DIR%glut_files"
set "OPENGL_32=%SCRIPT_DIR%OpenGL\32Bit"
set "OPENGL_64=%SCRIPT_DIR%OpenGL\64Bit"

:: Auto-detection check
set "DETECTED_PATH="
set "DETECTED_TYPE="

if exist "C:\Program Files\CodeBlocks\MinGW" (
    set "DETECTED_PATH=C:\Program Files\CodeBlocks"
    set "DETECTED_TYPE=1"
) else if exist "C:\Program Files (x86)\CodeBlocks\MinGW" (
    set "DETECTED_PATH=C:\Program Files (x86)\CodeBlocks"
    set "DETECTED_TYPE=2"
)

echo Available Code::Blocks Setup Options:
echo   [1] 32-Bit Code::Blocks (v17+) at C:\Program Files\CodeBlocks
echo   [2] 64-Bit Code::Blocks (v20+) at C:\Program Files (x86)\CodeBlocks
echo   [3] 64-Bit Code::Blocks (v20+) at C:\Program Files\CodeBlocks
echo   [4] Custom Path / Other Drive (e.g. D:\CodeBlocks)
if defined DETECTED_PATH (
    echo   [5] Auto-Detected: !DETECTED_PATH!
)
echo.

set /p CHOICE="Select option [1-5]: "

if "%CHOICE%"=="1" goto INSTALL_32_PROGFILES
if "%CHOICE%"=="2" goto INSTALL_64_PROGFILES_X86
if "%CHOICE%"=="3" goto INSTALL_64_PROGFILES
if "%CHOICE%"=="4" goto INSTALL_CUSTOM
if "%CHOICE%"=="5" (
    if "!DETECTED_TYPE!"=="1" goto INSTALL_32_PROGFILES
    if "!DETECTED_TYPE!"=="2" goto INSTALL_64_PROGFILES_X86
    goto INSTALL_32_PROGFILES
)

echo.
echo Invalid option selected. Defaulting to 64-Bit installation at C:\Program Files\CodeBlocks...
goto INSTALL_64_PROGFILES

:INSTALL_32_PROGFILES
set "CODEBLOCKS_DIR=C:\Program Files\CodeBlocks"
set "ARCH=32"
if exist "%OPENGL_32%" (
    echo.
    echo Copying pre-packaged 32-bit OpenGL files to C:\...
    xcopy /E /Y /I "%OPENGL_32%" "C:\" >nul
)
goto DO_INSTALL

:INSTALL_64_PROGFILES_X86
set "CODEBLOCKS_DIR=C:\Program Files (x86)\CodeBlocks"
set "ARCH=64"
if exist "%OPENGL_64%" (
    echo.
    echo Copying pre-packaged 64-bit OpenGL files to C:\...
    xcopy /E /Y /I "%OPENGL_64%" "C:\" >nul
)
goto DO_INSTALL

:INSTALL_64_PROGFILES
set "CODEBLOCKS_DIR=C:\Program Files\CodeBlocks"
set "ARCH=64"
goto DO_INSTALL

:INSTALL_CUSTOM
echo.
set /p CODEBLOCKS_DIR="Enter full path to Code::Blocks directory (e.g. D:\CodeBlocks): "
if "!CODEBLOCKS_DIR:~-1!"=="\" set "CODEBLOCKS_DIR=!CODEBLOCKS_DIR:~0,-1!"

echo.
echo Select Version / Architecture for custom location:
echo   [1] 32-Bit Code::Blocks (v17+)
echo   [2] 64-Bit Code::Blocks (v20+)
set /p ARCH_CHOICE="Select architecture [1-2]: "
if "!ARCH_CHOICE!"=="1" (
    set "ARCH=32"
) else (
    set "ARCH=64"
)
goto DO_INSTALL

:DO_INSTALL
set "MINGW=%CODEBLOCKS_DIR%\MinGW"
set "WIZARD_DEST=%CODEBLOCKS_DIR%\share\CodeBlocks\templates\wizard\glut\wizard.script"
set "MAIN_DEST=%CODEBLOCKS_DIR%\share\CodeBlocks\templates\wizard\glut\files\main.cpp"

if not exist "%MINGW%" (
    echo.
    echo [ERROR] MinGW directory not found at: "%MINGW%"
    echo Please verify your Code::Blocks installation path and try again.
    pause
    exit /b 1
)

echo.
echo Installing GLUT for %ARCH%-bit Code::Blocks at: "%CODEBLOCKS_DIR%"
echo.

if not exist "%MINGW%\include\GL" mkdir "%MINGW%\include\GL"

echo [1/5] Copying glut.h -> %MINGW%\include\GL...
copy /Y "%SRC%\glut.h" "%MINGW%\include\GL\glut.h"

if "%ARCH%"=="64" (
    echo [2/5] Copying 64-bit libglut32.a as libfreeglut.a, libglut32.a, libglut.a...
    copy /Y "%SRC%\libglut32_x64.a" "%MINGW%\lib\libfreeglut.a"
    copy /Y "%SRC%\libglut32_x64.a" "%MINGW%\lib\libglut32.a"
    copy /Y "%SRC%\libglut32_x64.a" "%MINGW%\lib\libglut.a"

    echo [3/5] Copying 64-bit glut32.dll ^& freeglut.dll to MinGW ^& System Folders...
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
    if exist "%SystemRoot%\SysWOW64" (
        copy /Y "%SRC%\glut32.dll" "%SystemRoot%\SysWOW64\freeglut.dll"
    )

    echo [4/5] Copying 64-bit DLL into local project output directories...
    for /r "%SCRIPT_DIR%.." %%d in (bin\Debug bin\Release) do (
        if exist "%%d" (
            echo   - Found project output folder: %%d
            copy /Y "%SRC%\glut32.dll" "%%d\freeglut.dll" >nul
            copy /Y "%SRC%\glut32.dll" "%%d\glut32.dll" >nul
            copy /Y "%SRC%\glut32.dll" "%%d\glut.dll" >nul
        )
    )
) else (
    echo [2/5] Copying 32-bit libglut32.a as libfreeglut.a, libglut32.a, libglut.a...
    copy /Y "%SRC%\libglut32.a" "%MINGW%\lib\libfreeglut.a"
    copy /Y "%SRC%\libglut32.a" "%MINGW%\lib\libglut32.a"
    copy /Y "%SRC%\libglut32.a" "%MINGW%\lib\libglut.a"

    echo [3/5] Copying 32-bit glut32.dll to MinGW ^& System Folders...
    set "DLL_32=%SRC%\glut32_32bit.dll"
    if not exist "!DLL_32!" set "DLL_32=%SRC%\glut32.dll"

    copy /Y "!DLL_32!" "%MINGW%\bin\freeglut.dll"
    copy /Y "!DLL_32!" "%MINGW%\bin\glut32.dll"
    copy /Y "!DLL_32!" "%MINGW%\bin\glut.dll"

    if exist "%SystemRoot%\SysWOW64" (
        copy /Y "!DLL_32!" "%SystemRoot%\SysWOW64\glut32.dll"
        copy /Y "!DLL_32!" "%SystemRoot%\SysWOW64\freeglut.dll"
        copy /Y "!DLL_32!" "%SystemRoot%\SysWOW64\glut.dll"
    ) else if exist "%SystemRoot%\System32" (
        copy /Y "!DLL_32!" "%SystemRoot%\System32\glut32.dll"
        copy /Y "!DLL_32!" "%SystemRoot%\System32\freeglut.dll"
        copy /Y "!DLL_32!" "%SystemRoot%\System32\glut.dll"
    )

    echo [4/5] Copying 32-bit DLL into local project output directories...
    for /r "%SCRIPT_DIR%.." %%d in (bin\Debug bin\Release) do (
        if exist "%%d" (
            echo   - Found project output folder: %%d
            copy /Y "!DLL_32!" "%%d\freeglut.dll" >nul
            copy /Y "!DLL_32!" "%%d\glut32.dll" >nul
            copy /Y "!DLL_32!" "%%d\glut.dll" >nul
        )
    )
)

echo [5/5] Fixing Code::Blocks GLUT Wizard script ^& main.cpp template...
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
echo   SUCCESS! GLUT setup applied cleanly for %ARCH%-bit Code::Blocks!
echo   Installation path: %CODEBLOCKS_DIR%
echo ============================================================
echo.
pause

