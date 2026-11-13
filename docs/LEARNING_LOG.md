   # FP1 Learning Log

   ## Lesson 0.1: WSL2
   - WSL2 is a VM for using Linux kernel (which manages processes, fs, memory etc) in a distro like ubuntu on a host windows machine.
   - Avoid using /mnt/c as this is where the windows C: drive is mounted in the WSL2 Ubuntu. Using this causes slow builds and builds read and write thousands of small files, and crossing the Windows/Linux boundary makes each one slow. Also Linux ends files with LF but in windows they end with CRLF, which could be a big issue in LinkerScripts/makefiles.
   - We open VS Code in wsl instead of opening in windows and navigating to the files because the windows/linux boundary is a slow path and compiling touches a lot of files which would be a slowww build. Also the VS server runs in WSL and not windows.

   ## Lesson 0.2: Terminal basics
   - ~ is my personal home (/home/<uname>), / is root and /mnt/c is where windows lives in my ubuntu image
   - absolute paths start from root, relative paths are relative to the pwd.
   
   ## Lesson 0.3: Toolchain
   - Host is WSl (Linux-Ubuntu Distro) and Target is ARM Cortex-M3
   - A Cross-Compiler is needed so we can compile machine code on an x86 machine but for an ARM based machine.

   ## Lesson 0.4: Git
   - Repository is the local .git folder, remote is a copy on github, staging area is where you keep your changes and working directory is where you're currently working on.
   - Three stages: modified, staged, committed
   
   ## Lesson 0.5: QEMU
   - What QEMU does NOT prove: For AN385, the remapping of the low 16K between ZBT SSRAM1 and block RAM is unimplemented.
   -  Machine model is the whole model(that gets simulated ) of the hardware with its memory, architecture, and the overall motherboard layout.
   - mps2-an385 has Cortex M3 CPU;PSRAM is 16MB with base as 0x21000000, Somewhere else in the document and not in memory map, I found UART0 BA=0x40004000

