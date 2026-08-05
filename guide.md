# Code::Blocks OpenGL / GLUT Setup & Troubleshooting Guide

## 1. Overview
This guide documents the complete setup of OpenGL/GLUT in Code::Blocks on modern Windows machines, explaining the root causes for common setup failures and providing a 1-click automated fix.

---

## 2. Technical Causes of Code::Blocks GLUT Errors

### 1. Architecture Mismatch (`skipping incompatible libglut32.a`)
* **Problem**: Standard legacy GLUT tutorials provide 32-bit (x86) library binaries (`libglut32.a` and `glut32.dll`).
* **Root Cause**: Modern Code::Blocks installs a 64-bit MinGW-w64 compiler toolchain (`x86_64-w64-mingw32`). When building a project, GCC's 64-bit linker skips 32-bit `.a` files because 32-bit objects cannot be linked into 64-bit binaries.
* **Fix**: Generated a 64-bit compatible import library (`libglut32_x64.a`) using `gendef.exe` and `dlltool.exe` with clean x64 symbol exports.

### 2. FreeGLUT Library Name Requirement (`wizard.script: freeglut missing`)
* **Problem**: Code::Blocks GLUT Wizard raises the error:
  > *The path you entered seems valid, but this wizard can't locate the following GLUT's library file: freeglut in it.*
* **Root Cause**: Code::Blocks updated its built-in project wizard (`wizard.script`) to explicitly search for `libfreeglut.a` instead of `libglut32.a` on Windows.
* **Fix**: Creating library aliases (`libfreeglut.a`, `libglut32.a`, `libglut.a`) satisfies both legacy GLUT and FreeGLUT wizard checks.

### 3. Wizard Condition Evaluation Bug (Clicking "Next" does nothing)
* **Problem**: Clicking "Next" on the GLUT location page silently fails and remains on the same page.
* **Root Cause**: Line 61 of Code::Blocks `wizard.script` contained an invalid boolean expression where successful `SilentVerifyLibFile` execution caused the page validation function `OnLeave_GlutPath` to return `false`.
* **Fix**: Updated `wizard.script` to use a non-blocking `&&` check across all supported library names:
  ```squirrel
  if (!SilentVerifyLibFile(dir_nomacro_lib, _T("freeglut")) &&
      !SilentVerifyLibFile(dir_nomacro_lib, _T("glut32")) &&
      !SilentVerifyLibFile(dir_nomacro_lib, _T("glut")))
  {
      if (!VerifyLibFile(dir_nomacro_lib, _T("freeglut"), _("GLUT's"))) return false;
  }
  ```

---

## 3. Quick 1-Click Automated Setup

To automatically install all headers, 64-bit library files, DLLs, and the updated wizard script:

1. Right-click `install_glut_admin.bat` and select **Run as administrator**.
2. Click **Yes** on the Windows Administrator prompt.
3. Wait for the `SUCCESS!` confirmation message.

---

## 4. How to Create & Run a GLUT Project in Code::Blocks

1. Open **Code::Blocks**.
2. Go to **File > New > Project...** -> Select **GLUT project** -> Click **Next**.
3. Enter your **Project Title** (e.g. `Lab_01_Shapes`) and choose your working folder.
4. When asked for the **GLUT location**, enter:
   ```text
   C:\Program Files\CodeBlocks\MinGW
   ```
5. Click **Next** -> Select **GNU GCC Compiler** -> Click **Finish**.
6. Open `main.cpp` and press **`F9`** (or click **Build and Run**).

---

## 5. Reference Files Included in Package

All reference files are stored inside the `glut_files` directory:
* **`glut.h`**: OpenGL GLUT C/C++ header file.
* **`libglut32_x64.a`**: 64-bit MinGW import library.
* **`glut32.dll`**: GLUT dynamic link library.
* **`wizard_fixed.script`**: Fixed Code::Blocks GLUT wizard script.
