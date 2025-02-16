MEMORY
{
    FLASH(rx) : ORIGIN = 0x10000000, LENGTH = 2048k
    RAM(rwx) : ORIGIN = 0x20000000, LENGTH = 256k
}

SECTIONS
{
    .text : {
        KEEP(*(.boot2))
        KEEP(*(.vectors))
        *(.text*)
    } > FLASH

    .rodata : {
        *(.rodata*)
    } > FLASH

    .data : {
        *(.data*)
    } > RAM AT> FLASH

    .bss : {
        *(.bss*)
        *(COMMON)
    } > RAM

    /DISCARD/ : {
        *(.ARM.attributes)
        *(.comment)
        *(.debug*)
    }
}
