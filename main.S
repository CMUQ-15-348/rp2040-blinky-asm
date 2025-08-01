.syntax unified
.cpu cortex-m0plus

.thumb_func
.global main

.equ    CLOCKS_BASE,    0x40008000
.equ    CLK_REF_OFFSET,    0x30
.equ    CLK_SYS_OFFSET,    0x3c

.equ    PADS_BANK0_BASE,0x4001c000
.equ    IO_BANK0_BASE,  0x40014000
.equ    SIO_BASE,       0xd0000000
.equ    RESETS_BASE,    0x4000c000
.equ    RESETS_BASE_CLR,0x4000f000

.equ    PADS_BANK0_GPIO25,  0x68 @ Offset for GPIO 25 pad control register
.equ    GPIO_25_CTRL,   0x0CC    @ Offset for GPIO 25 control register

.equ    DELAY_COUNT,    0x001FFFFF  @ Delay duration

main:
    ////////////////////
    // Reset the clock source to be the default on powerup: Ring oscillator.
    // Why?  Because if you program this over the debug probe, and it was previously
    // running a program that properly configured the clock, your delay will be too slow.

    // CLK_REF glitchless mux to ring oscillator
    ldr r0, =CLOCKS_BASE
    movs r1, #0
    str r1, [r0, #CLK_REF_OFFSET]
    // CLK_SYS glitchless mux to CLK_REF
    movs r1, #0
    str r1, [r0, #CLK_SYS_OFFSET]

    ////////////////////
    // Pull IO_BANK0 and PADS_BANK0 out of reset
    ldr r0, =RESETS_BASE_CLR	// atomic register for clearing reset controller (0x4000c000+0x3000) 
    // IO_BANK0
    movs r1, #1
    lsls r1, r1, #5     // load a 1 into bit 5 (IO_BANK0)
    str r1, [r0, #0] 	// store the bitmask into the atomic register to clear register
    // PADS_BANK0
    movs r1, #1
    lsls r1, r1, #8     // load a 1 into bit 8 (PADS_BANK0)
    str r1, [r0, #0] 	// store the bitmask into the atomic register to clear register

    ////////////////////
    // Initialize GPIO 25 for output
    ldr r0, =PADS_BANK0_BASE     @ Load PADS_BANK0 base address
    movs r1, #0                   @ Clear all bits
    str r1, [r0, #PADS_BANK0_GPIO25]          @ Configure pad (GPIO 25)

    ldr r0, =IO_BANK0_BASE       @ Load IO_BANK0 base address
    ldr r2, =GPIO_25_CTRL
    movs r1, #5                    @ Function 5 (SIO)
    str r1, [r0, r2]   @ Set GPIO 25 function

    ldr r0, =SIO_BASE            @ Load SIO base address
    movs r1, #1                    @ Bit mask for GPIO 25
    lsls r1, #25                  @ Shift to bit 25
    str r1, [r0, #0x024]         @ Set GPIO 25 as output

    ////////////////////
    // Loop to turn on the LED, delay, then turn it off, then delay again.
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
