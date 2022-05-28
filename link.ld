OUTPUT_FORMAT(elf32-i386)
ENTRY(_start)
SECTIONS
{
	. = 0x7c00;
	.text BLOCK(4K) : ALIGN(4K)
	{
		*(.text)
	}
	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}
	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(.bss) *(COMMON)
	}
}