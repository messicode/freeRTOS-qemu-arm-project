/*The first function that is called when the microcontroller is reset. 
QEMU's M-profile boot reads the vector table, but ENTRY is good practice and GDB would use this. */
ENTRY(Reset_Handler)

/*Defining memory regions for the linker script, that our firmware is allowed to use.
r=read, w=write, x=execute */
MEMORY
{
    CODE (rx) : ORIGIN = 0x00000000, LENGTH = 4M
    RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 4M
}



/*Symbol that holds the address of the top of the stack (1 past the end of RAM). The stack grows downward from here.*/
_estack = ORIGIN(RAM) + LENGTH(RAM);

/*Layout = output section : { input files } > memory region
Create an op section, Collect all ip sections matching name (w wildcard) and put result in mem region.*/
/*Tells the linker where to place different sections of the compiled code in memory*/
SECTIONS
{
    /*Vector table comes first at addr 0. KEEP stops the linker from throwing it away.*/
    .isr_vector :{ KEEP(*(.isr_vector)) } > CODE
    /*Text section contains the actual machine code.*/
    .text :{ *(.text*)} > CODE
    /*Read-only data section, which contains constants and string literals.*/
    .rodata :{*(.rodata*)} > CODE
}