/* Highest address of the user mode stack */
_estack = 0x20018000;    /* end of 96K RAM */
MEMORY
{
	/* Define each memory region */
	FLASH	(rx)	: ORIGIN = 0x08000000,	LENGTH = 512K
	RAM		(rwx)	: ORIGIN = 0x20000000,	LENGTH = 96K
}
SECTIONS
{
	.isr_vector :
	{
		KEEP(*(.isr_vector)) /* Startup code */
	} > FLASH

	.text :
	{
	. = ALIGN(4);
	*(.text*)
	. = ALIGN(4);
	_etext = .;
	} >FLASH
}