/* The code below is inspired by the SDK:
 * https://github.com/raspberrypi/pico-sdk/blob/166cb0fef6b9fdea9d256eb9647edbb7d058bf92/src/rp2_common/pico_standard_link/crt0.S
 */
.syntax unified
.cpu cortex-m0plus
.thumb_func
.global main

.section .reset, "ax"

// Clear the bss segment in RAM, making it all 0s
ldr r1, =__bss_start__
ldr r2, =__bss_end__
movs r0, #0
b bss_fill_test
bss_fill_loop:
    stm r1!, {r0}
bss_fill_test:
    cmp r1, r2
    bne bss_fill_loop

// Copy the data segment from flash to RAM
@ Load the addresses of data in flash and RAM
ldr r1, =__rodata_end__ @ address of the start of the .data variables in flash (we will copy from here)
ldr r2, =__data_start__ @ address of the start of the .data variables in RAM (we will copy to here)
ldr r3, =__data_end__   @ address of the end of the .data variables in RAM (we will copy to here)
@ Call our data copy routine to copy the .data from flash to RAM
b data_cpy
data_cpy_loop:
    ldm r1!, {r0}
    stm r2!, {r0}
data_cpy:
    cmp r2, r3
    blo data_cpy_loop

// Call main
b main