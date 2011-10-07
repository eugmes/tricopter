OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)
STARTUP(start.o)

ENTRY(_start)
EXTERN(_start __gnat_vectors)

/* Environment task stack size */
ENVIRONMENT_STACK_SIZE = DEFINED(ENVIRONMENT_STACK_SIZE) ? ALIGN(ENVIRONMENT_STACK_SIZE, 8) : 1k;
/* Interrupt handlers stack size */
INTERRUPT_STACK_SIZE = DEFINED(INTERRUPT_STACK_SIZE) ? ALIGN(INTERRUPT_STACK_SIZE, 8) : 1k;

MEMORY
{
    flash : ORIGIN = 0x00000000, LENGTH = 128k
    ram   : ORIGIN = 0x20000000, LENGTH = 64k
}

PHDRS
{
    text PT_LOAD;
    data PT_LOAD;
    bss  PT_NULL;
}

SECTIONS
{
    .vectors ORIGIN(flash) : { KEEP(*(.vectors)) } > flash :text
    ASSERT (. != 0, "Vector table is not present")

    .text : { *(.text) *(.text.*)} > flash

    .rodata : { *(.rodata) *(.rodata.*)} > flash

    .data ORIGIN(ram) : { *(.data) *(.data.*) } > ram AT> flash :data

    _flash_sdata = LOADADDR(.data);
    _sdata = ADDR(.data);
    _flash_edata = _flash_sdata + SIZEOF(.data);

    .bss : { *(.bss) *(.bss.*) } > ram AT> ram :bss

    _sbss = ADDR(.bss);
    _ebss = ADDR(.bss) + SIZEOF(.bss);

    .stack : ALIGN(8)
    {
        *(.stack)
	*(.stack.*)
	/* Environment task stack */
	. = ALIGN(8);
	__gnat_environment_stack = .;
	. += ENVIRONMENT_STACK_SIZE;
	__gnat_environment_stack_top = .;
	/* Interrupt stack */
	__gnat_interrupt_stack = .;
	. += INTERRUPT_STACK_SIZE;
	__gnat_interrupt_stack_top = .;
    } > ram AT> ram :bss

    /* DWARF 1 */
    .debug          0 : { *(.debug) } :NONE
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
