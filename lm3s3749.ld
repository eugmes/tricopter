OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
INPUT(libgnat.a)
ENTRY(_start)

MEMORY
{
    flash : ORIGIN = 0x00000000, LENGTH = 128k
    ram   : ORIGIN = 0x20000000, LENGTH = 64k
}

SECTIONS
{
    . = ORIGIN(flash);
    .vectors . : { KEEP(*(.vectors)) } > flash
    ASSERT (. != 0, "Vector table is not present")

    .text ALIGN(4) : { *(.text) } > flash

    .rodata ALIGN(8) : { *(.rodata) } > flash

    _flash_sdata = .;
    . = ORIGIN(ram);
    _sdata = .;
    .data ALIGN(8) : {
        *(.data)
        . = ALIGN(4);
    } > ram AT> flash
    _edata = .;
    _flash_edata = _flash_sdata + (_edata - _sdata);

    _sbss = .;
    .bss ALIGN(8) : {
        *(.bss)
        . = ALIGN(4);
    } > ram AT> ram
    _ebss = .;

    _stack_top = ORIGIN(ram) + LENGTH(ram);

    /* DWARF 1 */
    .debug          0 : { *(.debug) }
    .line           0 : { *(.line) }
    /* GNU DWARF 1 extensions */
    .debug_srcinfo  0 : { *(.debug_srcinfo) }
    .debug_sfnames  0 : { *(.debug_sfnames) }
    /* DWARF 1.1 and DWARF 2 */
    .debug_aranges  0 : { *(.debug_aranges) }
    .debug_pubnames 0 : { *(.debug_pubnames) }
    /* DWARF 2 */
    .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
    .debug_abbrev   0 : { *(.debug_abbrev) }
    .debug_line     0 : { *(.debug_line) }
    .debug_frame    0 : { *(.debug_frame) }
    .debug_str      0 : { *(.debug_str) }
    .debug_loc      0 : { *(.debug_loc) }
    .debug_macinfo  0 : { *(.debug_macinfo) }
    /* DWARF 2.1 */
    .debug_ranges   0 : { *(.debug_ranges) }
    /* SGI/MIPS DWARF 2 extensions */
    .debug_weaknames 0 : { *(.debug_weaknames) }
    .debug_funcnames 0 : { *(.debug_funcnames) }
    .debug_typenames 0 : { *(.debug_typenames) }
    .debug_varnames  0 : { *(.debug_varnames) }

    .note.gnu.arm.ident 0 : { KEEP (*(.note.gnu.arm.ident)) }
    .ARM.attributes 0 : { KEEP (*(.ARM.attributes)) }
    /DISCARD/ : { *(.note.GNU-stack) }
}
