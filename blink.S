.syntax unified
.cpu cortex-m0plus

.thumb_func
.global main

.equ    PADS_BANK0_BASE,0x4001c000
.equ    IO_BANK0_BASE,  0x40014000
.equ    SIO_BASE,       0xd0000000

.equ    PADS_BANK0_GPIO15, 0x40 @ Offset for GPIO 15 pad control register
.equ    GPIO_15_CTRL,   0x07C    @ Offset for GPIO 25 control register

.equ    PADS_BANK0_GPIO25,  0x68 @ Offset for GPIO 25 pad control register
.equ    GPIO_25_CTRL,   0x0CC    @ Offset for GPIO 25 control register

.equ    DELAY_COUNT,    0x01FFFFFF  @ Delay duration

main:
    // Initialize GPIO 15 for output
    ldr r0, =PADS_BANK0_BASE     @ Load PADS_BANK0 base address
    movs r1, #0                   @ Clear all bits
    str r1, [r0, #PADS_BANK0_GPIO15]          @ Configure pad (GPIO 15)

    ldr r0, =IO_BANK0_BASE       @ Load IO_BANK0 base address
    ldr r2, =GPIO_15_CTRL
    movs r1, #5                    @ Function 5 (SIO)
    str r1, [r0, r2]   @ Set GPIO 15 function

    ldr r0, =SIO_BASE            @ Load SIO base address
    movs r1, #1                    @ Bit mask for GPIO 15
    lsls r1, #15                  @ Shift to bit 15
    str r1, [r0, #0x024]         @ Set GPIO 15 as output

loop:
    // Turn LED on
    str r1, [r0, #0x014]         @ Set output high

    // Delay
    ldr r2, =DELAY_COUNT
delay1:
    subs r2, #1
    bne delay1

    // Turn LED off
    str r1, [r0, #0x018]         @ Set output low

    // Delay
    ldr r2, =DELAY_COUNT
delay2:
    subs r2, #1
    bne delay2

    b loop                        @ Repeat forever