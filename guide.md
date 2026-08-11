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

### 4. Header Include Order Bug (`_CRTIMP does not name a type`)
* **Problem**: Building a newly created GLUT project throws compilation errors such as:
  `corecrt_wstdlib.h|15|error: '_CRTIMP' does not name a type`
* **Root Cause**: Default Code::Blocks GLUT project template `main.cpp` places `#include <stdlib.h>` *below* `#include <GL/glut.h>`. When `glut.h` runs first on MinGW-w64, it defines and then `#undef`s internal Win32 CRT macros (`_CRTIMP`), causing GCC/MinGW header `#include <stdlib.h>` to fail during parsing.
* **Fix**: Placed `#include <stdlib.h>` *before* GLUT header includes in the fixed template (`glut_files\main.cpp`). `install_glut_admin.bat` replaces Code::Blocks' default `main.cpp` template (`%CODEBLOCKS_DIR%\share\CodeBlocks\templates\wizard\glut\files\main.cpp`) with this fixed template.

### 5. `0xc000007b` Application Error (`STATUS_INVALID_IMAGE_FORMAT`)
* **Problem**: Application crashes immediately on launch with dialog: `The application was unable to start correctly (0xc000007b)`.
* **Root Cause**: Architecture mismatch at runtime. The 64-bit compiler (`x86_64-w64-mingw32`) produced a 64-bit executable (`lab-1.exe`), but Windows tried to load a 32-bit `glut32.dll` from `%MINGW%\bin` or System32. A 64-bit process cannot load a 32-bit DLL.
* **Fix**: Run `install_glut_admin.bat` as Administrator. It copies the genuine 64-bit `glut32.dll` and `freeglut.dll` into `%MINGW%\bin`, `%SystemRoot%\System32`, and any local project output folders (`bin\Debug` / `bin\Release`).

### 6. `wxWidgets Debug Alert` (`assert "IsVisible(item)" failed in GetNextVisible()`)
* **Problem**: When creating a new GLUT project, Code::Blocks shows a dialog: `wxWidgets Debug Alert - assert "IsVisible(item)" failed in GetNextVisible(): The item you call GetNextVisible() for must be visible itself!`.
* **Root Cause**: An internal GUI debug assertion in Code::Blocks itself. When the wizard completes and automatically inserts the newly created project into the IDE's Management tree panel (`wxTreeCtrl`), Code::Blocks queries the tree item visibility before the panel finishes rendering.
* **Impact**: **Harmless**. It is purely an IDE interface alert and does **not** affect your project, compiler settings, or C++ source code.
* **Fix / Workaround**:
  1. Check **"Don't show this dialog again"** and click **Continue**.
  2. Ensure the Management view is visible (**View > Management** or press `Shift + F2`).
  3. If the layout state gets stuck, reset it via **View > Layouts > Standard**.






---

## 3. Automated Interactive Setup (32-Bit & 64-Bit)

To install all headers, library files, DLLs, and updated wizard scripts for your target Code::Blocks architecture:

1. Right-click `install_glut_admin.bat` and select **Run as administrator**.
2. Click **Yes** on the Windows Administrator prompt.
3. Select your installation configuration from the interactive prompt:
   - **[1] 32-Bit Code::Blocks (v17+)** at `C:\Program Files\CodeBlocks` (copies pre-packaged 32-bit OpenGL files from `OpenGL\32Bit` to local drive `C:`).
   - **[2] 64-Bit Code::Blocks (v20+)** at `C:\Program Files (x86)\CodeBlocks` (copies pre-packaged 64-bit OpenGL files from `OpenGL\64Bit` to local drive `C:`).
   - **[3] 64-Bit Code::Blocks (v20+)** at `C:\Program Files\CodeBlocks`.
   - **[4] Custom Path / Other Drive** (e.g., `D:\CodeBlocks` or `E:\Program Files\CodeBlocks`).
   - **[5] Auto-Detected** (if a standard Code::Blocks installation was detected automatically).
4. Wait for the `SUCCESS!` confirmation message.

### Uninstallation / Cleanup:
To cleanly remove all installed GLUT files (including previous/legacy setup files) and restore original settings:
1. Right-click `uninstall_glut_admin.bat` and select **Run as administrator**.
2. Select your installed Code::Blocks folder or clean all standard locations.
3. All headers, libraries (`.a`), DLLs (from MinGW, System32, SysWOW64, and project output folders), and modified wizard scripts will be completely removed and restored to defaults.

---

## 4. Custom Installation Paths / Different Drives (e.g. `D:\` Drive)

If Code::Blocks is installed on another drive or a custom folder (such as `D:\CodeBlocks` or `E:\Program Files\CodeBlocks`):

1. Right-click `install_glut_admin.bat` and select **Run as administrator**.
2. Select Option **`[4] Custom Path / Other Drive`**.
3. When prompted, enter the full path to your Code::Blocks directory (for example: `D:\CodeBlocks`).
4. Select the architecture version when prompted (`1` for 32-bit / v17+ or `2` for 64-bit / v20+).
5. The installer script will automatically configure `%CODEBLOCKS_DIR%\MinGW`, System DLLs, and wizard template scripts for that location without requiring manual file edits.


---

## 5. How to Create & Run a GLUT Project in Code::Blocks

### Option A: Create a New GLUT Project
1. Open **Code::Blocks**.
2. Go to **File > New > Project...** -> Select **GLUT project** -> Click **Next**.
3. Enter your **Project Title** (e.g. `Lab_01_Shapes`) and choose your working folder.
4. When asked for the **GLUT location**, enter your Code::Blocks MinGW folder (e.g., `C:\Program Files\CodeBlocks\MinGW` or `D:\CodeBlocks\MinGW`).
5. Click **Next** -> Select **GNU GCC Compiler** -> Click **Finish**.
6. Open `main.cpp` and press **`F9`** (or click **Build and Run**).

### Option B: Open an Existing Project (e.g. `Lab_1_codes`)
1. Go to **File > Open...**.
2. Navigate to your project `.cbp` file (e.g., `C:\Users\...\Downloads\Lab_1_codes\first\first.cbp`).
3. Open `main.cpp` and press **`F9`** to compile and launch.

---

### 💡 Cross-Platform GLUT Header Inclusion
For maximum compatibility across Windows, Linux, and macOS, always use preprocessor guards at the top of your `main.cpp`:

```cpp
#include <stdlib.h>
#include <stdio.h>

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif
```

---

### 🎨 3D Spinning Shapes Code Sample
Below is a complete, working GLUT 3D Spinning Shapes demo displaying rotating wireframe and smooth-shaded primitives:

```cpp
#include <stdlib.h>
#include <stdio.h>

#ifdef __APPLE__
#include <GLUT/glut.h>
#else
#include <GL/glut.h>
#endif

static int slices = 16;
static int stacks = 16;

static void resize(int width, int height)
{
    const float ar = (float) width / (float) height;
    glViewport(0, 0, width, height);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustum(-ar, ar, -1.0, 1.0, 2.0, 100.0);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
}

static void display(void)
{
    const double t = glutGet(GLUT_ELAPSED_TIME) / 1000.0;
    const double a = t * 90.0;

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glColor3d(1, 0, 0);

    glPushMatrix();
        glTranslated(-2.4, 1.2, -6);
        glRotated(60, 1, 0, 0);
        glRotated(a, 0, 0, 1);
        glutWireSphere(1, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(0, 1.2, -6);
        glRotated(60, 1, 0, 0);
        glRotated(a, 0, 0, 1);
        glutSolidCone(1, 1, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(2.4, 1.2, -6);
        glRotated(60, 1, 0, 0);
        glRotated(a, 0, 0, 1);
        glutWireTorus(0.2, 0.7, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(-2.4, -1.2, -6);
        glRotated(60, 1, 0, 0);
        glRotated(a, 0, 0, 1);
        glutSolidSphere(1, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(0, -1.2, -6);
        glRotated(60, 1, 0, 0);
        glRotated(a, 0, 0, 1);
        glutWireCone(1, 1, slices, stacks);
    glPopMatrix();

    glPushMatrix();
        glTranslated(2.4, -1.2, -6);
        glRotated(60, 1, 0, 0);
        glRotated(a, 0, 0, 1);
        glutSolidTorus(0.2, 0.7, slices, stacks);
    glPopMatrix();

    glutSwapBuffers();
}

static void key(unsigned char key, int x, int y)
{
    switch (key)
    {
        case 27 :
        case 'q':
            exit(0);
            break;
        case '+':
            slices++; stacks++;
            break;
        case '-':
            if (slices > 3 && stacks > 3) { slices--; stacks--; }
            break;
    }
    glutPostRedisplay();
}

static void idle(void)
{
    glutPostRedisplay();
}

const GLfloat light_ambient[]  = { 0.0f, 0.0f, 0.0f, 1.0f };
const GLfloat light_diffuse[]  = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat light_specular[] = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat light_position[] = { 2.0f, 5.0f, 5.0f, 0.0f };

const GLfloat mat_ambient[]    = { 0.7f, 0.7f, 0.7f, 1.0f };
const GLfloat mat_diffuse[]    = { 0.8f, 0.8f, 0.8f, 1.0f };
const GLfloat mat_specular[]   = { 1.0f, 1.0f, 1.0f, 1.0f };
const GLfloat high_shininess[] = { 100.0f };

int main(int argc, char *argv[])
{
    glutInit(&argc, argv);
    glutInitWindowSize(640, 480);
    glutInitWindowPosition(10, 10);
    glutInitDisplayMode(GLUT_RGB | GLUT_DOUBLE | GLUT_DEPTH);

    glutCreateWindow("GLUT 3D Spinning Shapes Demo");

    glutReshapeFunc(resize);
    glutDisplayFunc(display);
    glutKeyboardFunc(key);
    glutIdleFunc(idle);

    glClearColor(1, 1, 1, 1);
    glEnable(GL_CULL_FACE);
    glCullFace(GL_BACK);

    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LESS);

    glEnable(GL_LIGHT0);
    glEnable(GL_NORMALIZE);
    glEnable(GL_COLOR_MATERIAL);
    glEnable(GL_LIGHTING);

    glLightfv(GL_LIGHT0, GL_AMBIENT,  light_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE,  light_diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, light_specular);
    glLightfv(GL_LIGHT0, GL_POSITION, light_position);

    glMaterialfv(GL_FRONT, GL_AMBIENT,   mat_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE,   mat_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR,  mat_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, high_shininess);

    glutMainLoop();
    return EXIT_SUCCESS;
}
```


---

## 6. Reference Files Included in Package

All reference files are stored inside the `glut_files` directory:
* **`glut.h`**: OpenGL GLUT C/C++ header file.
* **`libglut32_x64.a`**: 64-bit MinGW import library.
* **`glut32.dll`**: GLUT dynamic link library.
* **`wizard_fixed.script`**: Fixed Code::Blocks GLUT wizard script.
* **`main.cpp`**: Fixed Code::Blocks GLUT main.cpp template (`#include <stdlib.h>` placed before GLUT header includes).
