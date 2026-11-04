   # FP1 Learning Log

   ## Lesson 0.1: WSL2
   - WSL2 is a VM for using Linux kernel (which manages processes, fs, memory etc) in a distro like ubuntu on a host windows machine.
   - Avoid using /mnt/c as this is where the windows C: drive is mounted in the WSL2 Ubuntu. Using this causes slow builds and builds read and write thousands of small files, and crossing the Windows/Linux boundary makes each one slow. Also Linux ends files with LF but in windows they end with CRLF, which could be a big issue in LinkerScripts/makefiles.
   - We open VS Code in wsl instead of opening in windows and navigating to the files because the windows/linux boundary is a slow path and compiling touches a lot of files which would be a slowww build. Also the VS server runs in WSL and not windows.

   ## Lesson 0.2: Terminal basics
   - ~ is my personal home (/home/<uname>), / is root and /mnt/c is where windows lives in my ubuntu image
   - absolute paths start from root, relative paths are relative to the pwd.
   

    ## Lesson 0.3: Toolchain