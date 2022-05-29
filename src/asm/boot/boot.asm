; I'm going to leave this note here so all you bitches know: setting up the development environment for this took ~20 hours, it's very much custom

[bits 16]
[extern _main]
[org 0x7c00]

; Stack

section .bss
stack_bottom:
resb 512 ; 512 bytes for stack
stack_top:

; Data section

;section .data

; Kernel entry

section .text

global _start
_start: ; This area will focus on initial setup and loading the rest of the kernel
	; Init stack
	mov bp, $stack_bottom
	mov sp, $stack_top

	mov bx, $working_msg
	call print

	jmp $
	hlt

%include "io.asm"

failsafe: jmp $ ; Should never be executed, failsafe

working_msg: db 'This is a test', 0

; Fill out 512 bytes space, add magic number to designate this as a bootsector
times 510 - ($-$$) db 0
dw 0xaa55