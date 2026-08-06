# Code::Blocks 64-Bit OpenGL / GLUT Setup & Fixes

An automated setup package and comprehensive technical guide for configuring OpenGL / GLUT in **Code::Blocks** on 64-bit Windows environments. Solves architecture mismatch errors, wizard script bugs, and `0xc000007b` launch crashes out of the box.

---

## 📖 Complete Setup & Troubleshooting Guide
For in-depth explanations of root causes, technical fixes, and custom installation paths:
👉 **[Read the complete guide in guide.md](guide.md)**

<img width="1112" height="432" alt="Code::Blocks GLUT Setup Demonstration" src="https://github.com/user-attachments/assets/dd90124e-385d-4079-9656-b7b53ee164e0" />

---

## 📂 Project File Structure

```
glut_project_setup/
├── README.md                  # Project overview & documentation
├── guide.md                   # Comprehensive technical troubleshooting guide & manual setup
├── install_glut_admin.bat     # 1-Click Administrator installer script
├── uninstall_glut_admin.bat   # Administrator cleanup & uninstallation script
├── organize.py                # Python helper script for organizing 64-bit GLUT binaries
├── prompt.txt                 # Generation prompt history / task requirements
├── glut_files/                # Core 64-bit GLUT library binaries & wizard patch
│   ├── glut.h                 # C/C++ OpenGL GLUT header file
│   ├── libglut32_x64.a        # 64-bit MinGW static import library
│   ├── libglut32.a            # Alias static library for legacy wizard compatibility
│   ├── glut32.dll             # Genuine 64-bit GLUT dynamic library
│   ├── freeglut.dll           # Genuine 64-bit FreeGLUT dynamic library
│   ├── glut.dll               # Generic GLUT dynamic library link
│   ├── glut32_32bit.dll       # Legacy 32-bit DLL backup
│   ├── glut32_x64.def         # 64-bit DLL export definition file
│   └── wizard_fixed.script    # Patched Code::Blocks GLUT wizard script
├── sample_labs/               # Sample OpenGL laboratory assignments & reference documents
│   ├── Basic 2D Shapes.txt
│   ├── Catch The Falling Ball.txt
│   ├── Introduction to OpenGL.ppt
│   ├── Lab 01 2D.docx
│   └── class work lab01 CG B grp.docx
└── prompts/                   # Detailed setup notes and troubleshooting transcripts
    ├── 1. Setting Up GLUT in Code__Blocks.md
    ├── 2. C__Program_. Is it safe to remove_.md
    └── 3. Fixes for build errors due to 32 bit installation.md
```

---

## ⚡ Quick Start (1-Click Automated Setup)

1. Right-click **`install_glut_admin.bat`** and select **Run as Administrator**.
2. Confirm the Windows UAC prompt.
3. Once the installation completes, open **Code::Blocks** and create a new **GLUT project**.
4. Set your GLUT location path to your MinGW directory (e.g., `C:\Program Files\CodeBlocks\MinGW`).
5. Build and run (`F9`) your project!

To undo changes or perform a clean reinstall, run **`uninstall_glut_admin.bat`** as Administrator.

