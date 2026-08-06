import shutil
import os

base = r"c:\Users\gsmur\Documents\GitHub\[personal]\glut_project\glut_project_setup"
glut = os.path.join(base, "glut_files")
dll_64 = os.path.join(glut, "mingw64", "bin", "libfreeglut.dll")

# 1. Backup old 32-bit dll
shutil.copy(os.path.join(glut, "glut32.dll"), os.path.join(glut, "glut32_32bit.dll"))

# 2. Overwrite glut32.dll and freeglut.dll with genuine 64-bit DLL
shutil.copy(dll_64, os.path.join(glut, "glut32.dll"))
shutil.copy(dll_64, os.path.join(glut, "freeglut.dll"))
shutil.copy(dll_64, os.path.join(glut, "glut.dll"))

# 3. Clean up temp files
shutil.rmtree(os.path.join(glut, "mingw64"), ignore_errors=True)
for temp_file in ["pkg.tar.zst", ".BUILDINFO", ".MTREE", ".PKGINFO"]:
    p = os.path.join(glut, temp_file)
    if os.path.exists(p):
        os.remove(p)

for temp_file in ["fetch_glut.py", "out.txt"]:
    p = os.path.join(base, temp_file)
    if os.path.exists(p):
        os.remove(p)

print("SUCCESSFULLY ORGANIZED 64-BIT GLUT FILES!")
