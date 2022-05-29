print: ; bx will point to string
	pusha

	mov ah, 0x0e     ; To set up printing

	mov al, 'x'
	int 0x10
	mov al, byte [bx]
	int 0x10

	.start_t:
	mov al, byte [bx]
	int 0x10
	inc bx
	cmp [bx], byte 0
	jne .start_t

	popa
	ret