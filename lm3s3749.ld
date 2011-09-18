OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
INPUT(libgnat.a)
ENTRY(_start)

MEMORY
{
    flash : ORIGIN = 0x00000000, LENGTH = 128k
    ram   : ORIGIN = 0x20000000, LENGTH = 64k
}

PHDRS
{

}

SECTIONS
{
    . = ORIGIN(flash);
    .vectors . : {
        KEEP(*(.vectors))
    } > flash

    .text ALIGN(4) : {
        *(.text)
    } > flash

    .rodata ALIGN(4) : {
        *(.rodata)
    } > flash

    _flash_sdata = .;
    . = ORIGIN(ram);
    _sdata = .;
    .data . : {
        *(.data)
    	. = ALIGN(4);
    } > ram AT> flash
    _edata = .;
    _flash_edata = _flash_sdata + (_edata - _sdata);

    _sbss = .;
    .bss . : {
        *(.bss)
    	. = ALIGN(4);
    } > ram AT> ram
    _ebss = .;

    _stack_top = ORIGIN(ram) + LENGTH(ram) - 4; /* FIXME */
}
