# Code::Blocks 32-Bit & 64-Bit OpenGL / GLUT Setup & Fixes

An automated setup package and comprehensive technical guide for configuring OpenGL / GLUT in **Code::Blocks (v17+ 32-Bit and v20+ 64-Bit)** on Windows environments. Solves architecture mismatch errors, wizard script bugs, header inclusion order issues, and `0xc000007b` launch crashes out of the box across standard and custom installation paths (e.g., `D:\` drive).

---

> [!IMPORTANT]
> 📖 **Full Technical & Troubleshooting Guide Available**  
> For in-depth explanations of root causes, header include fixes, custom drive setups, manual installation steps, and troubleshooting:  
> 👉 **[Read the complete technical guide in guide.md](guide.md)**


---

## ⚡ Quick Start (Automated Setup)

1. Right-click **`install_glut_admin.bat`** and select **Run as Administrator**.
2. Confirm the Windows UAC prompt.
3. Select your installation configuration from the interactive menu:
   - **`[1]` 32-Bit Code::Blocks (v17+)** (`C:\Program Files\CodeBlocks`)
   - **`[2]` 64-Bit Code::Blocks (v20+)** (`C:\Program Files (x86)\CodeBlocks`)
   - **`[3]` 64-Bit Code::Blocks (v20+)** (`C:\Program Files\CodeBlocks`)
   - **`[4]` Custom Path / Other Drive** (e.g., `D:\CodeBlocks` or `E:\Program Files\CodeBlocks`)
   - **`[5]` Auto-Detected** (if automatically detected)
4. Once installation completes, open **Code::Blocks** and create a new **GLUT project**.
5. Set your GLUT location path to your MinGW directory (e.g., `C:\Program Files\CodeBlocks\MinGW` or `D:\CodeBlocks\MinGW`).
6. Build and run (`F9`) your project!

To undo changes or perform a clean reinstall, right-click **`uninstall_glut_admin.bat`** and select **Run as Administrator**.

---

## ✨ Features & What's New

- ⚡ **Dual Architecture Support**: Seamlessly supports both **32-Bit (Code::Blocks v17+)** and **64-Bit (Code::Blocks v20+)** setups.
- 🎯 **Interactive & Auto-Detection**: Auto-detects standard installation paths or provides an interactive menu to choose your setup.
- 📂 **Multi-Drive / Custom Path Support**: Installs cleanly to custom folders and non-`C:` drives (e.g., `D:\CodeBlocks`).
- 🛠️ **Automated Bug Fixes**:
  - Fixes GCC architecture link mismatches (`skipping incompatible libglut32.a`).
  - Patches Code::Blocks GLUT wizard bugs (`wizard.script: freeglut missing` and non-responsive "Next" button).
  - Resolves CRT header inclusion order errors (`_CRTIMP does not name a type`).
  - Eliminates runtime `0xc000007b` launch crashes by deploying architecture-matched DLLs.

---

## 📂 Project File Structure

```
glut_project_setup/
├── README.md                  # Project overview & quick start guide
├── guide.md                   # Comprehensive technical troubleshooting guide & manual setup
├── install_glut_admin.bat     # Interactive Administrator installer (32-bit & 64-bit)
├── uninstall_glut_admin.bat   # Administrator cleanup & uninstallation script
├── organize.py                # Python helper script for organizing 64-bit GLUT binaries
├── prompt.txt                 # Task requirements history
├── glut_files/                # Core GLUT libraries, fixed wizard scripts, & fixed main.cpp template
│   ├── glut.h                 # C/C++ OpenGL GLUT header file
│   ├── libglut32_x64.a        # 64-bit MinGW static import library
│   ├── libglut32.a            # Alias static library for legacy wizard compatibility
│   ├── glut32.dll             # Genuine 64-bit GLUT dynamic library
│   ├── freeglut.dll           # Genuine 64-bit FreeGLUT dynamic library
│   ├── glut.dll               # Generic GLUT dynamic library link
│   ├── glut32_32bit.dll       # Legacy 32-bit DLL backup
│   ├── glut32_x64.def         # 64-bit DLL export definition file
│   ├── wizard_fixed.script    # Patched Code::Blocks GLUT wizard script
│   └── main.cpp               # Fixed GLUT main.cpp project template
├── OpenGL/                    # Pre-packaged 32-bit and 64-bit directory mirrors
│   ├── 32Bit/                 # Structured files for 32-bit Code::Blocks (v17+)
│   └── 64Bit/                 # Structured files for 64-bit Code::Blocks (v20+)
├── sample_labs/               # Sample OpenGL laboratory assignments & reference documents
│   ├── Basic 2D Shapes.txt
│   ├── Catch The Falling Ball.txt
│   ├── Introduction to OpenGL.ppt
│   ├── Lab 01 2D.docx
│   └── class work lab01 CG B grp.docx
└── prompts/                   # Detailed setup notes and troubleshooting transcripts
    ├── 1. Setting Up GLUT in Code__Blocks.md
    ├── 2. C__Program_. Is it safe to remove_.md
    ├── 3. Fixes for build errors due to 32 bit installation.md
    ├── 4. updating README.md
    ├── 5. removing absolute path.md
    ├── 6. project run guide.md
    ├── 7. debug alert issue.md
    ├── 8. Fixing GLUT Header Include Order.md
    ├── 9. upgrading script to support both 32 and 64bit installation.md
    ├── 9.1 Support 32-Bit & 64-Bit Code__Blocks (v17+_ v20+).md
    └── 9.2 Walkthrough - 32-Bit & 64-Bit Code__Blocks GLUT Installer Update.md
```

---


👉 For detailed manual setup instructions, technical root causes, and sample code, see **[guide.md](guide.md)**.


