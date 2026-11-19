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
   - What QEMU does NOT prove: 
     - For AN385, the remapping of the low 16K between ZBT SSRAM1 and block RAM is unimplemented. The lowest 16K can map to either ZBT SSRAM1 or the block RAM. QEMU always uses ZBT SSRAM1 and doesn’t implement the choice. 
     - In QEMU the “code” region is ordinary writable RAM. On a real chip the code lives in flash, which a stray store can’t overwrite like that. A bug that corrupts your code would behave differently on real hardware.
   - Machine model is the whole model(that gets simulated ) of the hardware with its memory, architecture, and the overall motherboard layout.
   - mps2-an385 has Cortex M3 CPU;PSRAM is 16MB with base as 0x21000000, Somewhere else in the document and not in memory map, I found UART0 base_address=0x40004000; info mtree gave all the memory mapping for this qemu machine model including the code memory which has base address = 0x000000000... also called mps.ssram1. Although its a ram for qemu boards, this was used as code memory as this is the address range from where Program Counter and Stack Pointer load on hardware reset. 
   - The source code file (mostly .c) is what actually runs, so it’s the ground truth for QEMU. It’s not necessarily the truth for a real board, which we will remember in the README.

   ## Lesson 1.1: Mental Model
   - On reset the hardware loads the word 0 into SP and word 1 into PC. Then it starts fetching instructions from PC and executing them. Word 1 last bit is 1 indicating Thumb code.
   - Before the main.c program gets executed C expects: initialized global variables are copied into RAM, unintialized globals are zeroed, then main() is called.
   - Stack is required to maintain function calls. Each call pushes its return address and their local variables. SP points to the stacks top. C needs this stack to call any functions.
   - Vector Table is an array of 32 bit words at the start of memory. W0 holds the SP and W1 has the address of the code that runs intially ie. reset handler. Later words hold the exception and interrupt handlers addresses.


             ARM CORTEX-M3 MEMORY MAP
          (Low address → High address)

     ┌──────────────────────────────┐
     │          NVIC / PPB          │
     │          I/O                │
     │  0xE0000000 - 0xE00FFFFF   │
     ├──────────────────────────────┤
     │                              │
     │          UART                │
     │          I/O                │
     │  0x40004000 - 0x40004FFF   │
     ├──────────────────────────────┤
     │                              │
     │          PSRAM               │
     │          RAM                 │
     │  0x21000000 - 0x21FFFFFF   │
     │          16 MB               │
     ├──────────────────────────────┤
     │                              │
     │          SSRAM23             │
     │          RAM                 │
     │  0x20000000 - 0x203FFFFF   │
     │          4 MB                │
     ├──────────────────────────────┤
     │                              │
     │          BLOCKRAM            │
     │          RAM                 │
     │  0x01000000 - 0x01003FFF   │
     │          16 KB               │
     ├──────────────────────────────┤
     │                              │
     │          SSRAM1              │
     │          RAM                 │
     │  0x00000000 - 0x003FFFFF   │
     │          4 MB                │
     │                              │
     │  Potential firmware/code    │
     └──────────────────────────────┘

             LOWEST ADDRESS
                0x00000000

   ## Lesson 2.1: First bootable image
   - vector table is where the CPU starts, the w0 and w1 are loaded from the vector table into the SP and PC. So vector table holds the _estack and reset handler symbols. 
   - Linker script tells the compiler about the memory layout, the estack/stack starting point and the entry point. It also defines the different sections our code would need and the entry point. 
   - If we modify the RAM size to 64K from 4M, the _estack symbol becomes 20010000 (Checked by changing ram size too)
   - Understanding the command used: Without -nostdlib, gcc would also link the C library and the standard startup code. That code expects an operating system, and it brings its own entry point. Without -ffreestanding, the compiler may assume library functions behave in standard ways and optimize around them. Neither is wanted when there is no OS.
   - 'make run' first checks if therea need to build the elf files. Then it starts QEMU and (for now) runs the CPU in an infinite loop. The loop is silent as it has nothing to print/do. Since there was no lockup, that signals the CPU didnt hard-fault.
