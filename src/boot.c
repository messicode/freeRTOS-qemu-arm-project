#include<stdint.h>

// End of stack address (not variable) defined in the linker script
// This symbol is used to initialize the stack pointer (SP) register
// This stack grows downwards, towards the lower memory addresses.
extern uint32_t _estack; 

void Reset_Handler(void);

/* The vector table: an array of 32-bit words.
   - 'const' keeps it read-only, so it lands in .rodata-like data.
   - section(".isr_vector") puts it in a section named .isr_vector,
     which the linker script places FIRST, at address 0.
   - 'used' stops the compiler from deleting it as "unused". */
__attribute__((section(".isr_vector"), used))
const uint32_t vector_table[] = {
    (uint32_t)&_estack,        // w0: Initial stack pointer value
    (uint32_t)Reset_Handler,   // w1: Reset handler address
};

//The first code the CPU runs. It sets nothing up and loops forever. This is a placeholder for the actual reset handler.
void Reset_Handler(void) 
{
    while(1){
        //does nothing; loops forever;
    }
}