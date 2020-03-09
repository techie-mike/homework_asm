;-----------------------------------------------------------------------
;	All function in this file:
;	_conv_num_bin
;	_conv_num_oct
;	_conv_num_hex
;	_write_symb
;	_write_string
;	_conv_num_dec
;
;-----------------------------------------------------------------------
;	Convert number to string in binary look (only 32bit number)
;	Entry:	EDI	pointer to space string for number (32 character)
;		EDX	number
;-----------------------------------------------------------------------
;	Destr:	EDI EAX
;-----------------------------------------------------------------------
ascii_zero	equ	48

_conv_num_bin:
		mov ecx, 32
		
	.loop:  rol edx, 1
		mov eax, edx

		and eax, 1
		add al, ascii_zero
		stosb
		loop .loop	
		                                                                  
		ret


;-----------------------------------------------------------------------
;	Convert number to string in octal look (only 32bit number)
;	Entry:	EDI	pointer to space string for number (32 character)
;		EDX	number
;-----------------------------------------------------------------------
;	Destr:	EDI EAX
;-----------------------------------------------------------------------
_conv_num_oct:
		mov ecx, 10
		rol edx, 2
		mov eax, edx
		and eax, 03h	; 011b
		add al, ascii_zero
		stosb

	.loop:	rol edx, 3
		mov eax, edx
		and eax, 07h
		add al, ascii_zero
		stosb
		loop .loop

		ret


;-----------------------------------------------------------------------
;	Convert number to string in hexadecimal look (only 32bit number)
;	Entry:	EDI	pointer to space string for number (32 character)
;		EDX	number
;-----------------------------------------------------------------------
;	Destr:	EDI EAX
;-----------------------------------------------------------------------
_conv_num_hex:
		mov ecx, 8

	.loop:	rol edx, 4
		mov eax, edx
		and eax, 0Fh
		cmp al, 9
		jb .offset
		add al, 7

	.offset:add al, ascii_zero
		stosb
		loop .loop

		ret


;-----------------------------------------------------------------------
;	Write symbol
;	Entry:	EDI	pointer to space string for symbol
;		EDX	number
;-----------------------------------------------------------------------
;	Destr:	EAX
;-----------------------------------------------------------------------
_write_symb:
		mov eax, edx
		stosb
		ret


;-----------------------------------------------------------------------
;	Write string
;	Entry:	EDX	pointer to writing string
;		EDI	pointer to space string for number (32 character)
;-----------------------------------------------------------------------
;	Destr:	EDI ESI EAX
;-----------------------------------------------------------------------
_write_string:
		mov esi, edx
		mov ah, 0
	.while:	lodsb
		cmp al, ah
		je .ret
		stosb
		jmp .while

	.ret:	ret



;-----------------------------------------------------------------------
;	Convert number to string in decimal look (only 32bit number)
;	Entry:	EDI	pointer to space string for number (32 character)
;		EDX	number
;-----------------------------------------------------------------------
;	Destr:	EDI EAX ECX EDX ESI ES
;-----------------------------------------------------------------------
_conv_num_dec:
		mov ecx, 10
		mov esi, 10
		mov eax, edx

	.loop:	mov edx, 0
		div esi
		add dl, ascii_zero
		mov [temp_str_dec_number + ecx - 1], dl
		loop .loop
		
		mov ecx, ds
		mov es, ecx
		mov esi, temp_str_dec_number

		mov ecx, 10
		rep movsb 

		ret
temp_str_dec_number	times 10 db 0
