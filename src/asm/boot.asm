[bits 16]
[extern _main]

section .bss
stack_bottom:
resb 16384 ; 16 KiB for stack
stack_top:

; Kernel entry

section .text
global _start
_start: ; This area will focus on initial setup and loading the rest of the kernel
	mov ah, 0x0e
	mov al, 'f'
	int 0x10

	;cli ; Disable interupts
	;mov $stack_top, %esp
	jmp $

	; Fill out 512 bytes space, add magic number to designate this as a bootsector
	times 510 - ($-$$) db 0
	dw 0xaa55