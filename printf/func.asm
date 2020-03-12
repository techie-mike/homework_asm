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



;------------------------------------------------------------------
;	Functions for exit from program (only in Windows)
;	Destr:	EAX
;------------------------------------------------------------------
exit:	
		xor eax, eax
                push eax                ; ExitCode = 0
                call [ExitProcess]      ; ExitProcess (0)
		ret


;------------------------------------------------------------------
;	Writes the string by format to the standard output (in console)
;	Param:	1) Arguments - the value for replace format specified.
;		push all arguments in reverse order 
;		(those start with the last one)
;
;		2) Format - string to write. It can optionally contain 
;		embedded format specifiers that are replaced by 
;		the values specified in subsequent additional arguments	
;------------------------------------------------------------------
;	IMPORTANT	
;	Push all arguments in reverse order (those start with the last one),
;	push the last address of the format
;------------------------------------------------------------------
printf:				; without prefix '_', because it is 
				; function for user
		push ebp
		mov ebp, esp

%define		format		ebp + 8
%define 	arguments	ebp + 12
	
		mov edi, str_printf	; it's template decision
		
		lea eax, [arguments]
		push eax
		push dword [format]
		push dword str_printf
		call _sprintf
		        		
		mov edi, str_printf
		call _print
		
		mov esp, ebp
		pop ebp
		ret
%undef		format
%undef		arguments


;------------------------------------------------------------------
;	Function for print EDX bytes in consol from pointer EDI (only Windows)
;	Entry:	EDI	pointer on string
;		EDX	number of characters
;------------------------------------------------------------------
;	Destr:	EAX EBX ECX EDX
;------------------------------------------------------------------
_print:	
		push dword -11
		call [GetStdHandle]
		        
		xor ebx, ebx
		push ebx
		push ebx
		push edx

		push edi
		push eax
		call [WriteConsoleA]

		ret


;------------------------------------------------------------------
;	Writes the string by format to the string
;	Param:	1) Pointer on arguments
;		Arguments - the value for replace format specified.
;		push all arguments in reverse order 
;		(those start with the last one)
;
;		2) Pointer on format 
;		Format - string to write. It can optionally contain 
;		embedded format specifiers that are replaced by 
;		the values specified in subsequent additional arguments
;
;		3) Place to write a string	
;------------------------------------------------------------------
;	IMPORTANT	
;	Push pointer on arguments, then pointer on format and pointer
;	on place to write string
;------------------------------------------------------------------
_sprintf:
		push ebp
		mov ebp, esp                      

%define		string		ebp + 8
%define		format		ebp + 12	
%define		arguments	ebp + 16


		mov edi, [string]
		mov esi, [format]

	;----------------------------
	.while:	
		lodsb
		mov ah, 0
		cmp al, ah
		je .end_loop
		

		mov ah, '%'
		cmp al, ah
		jne .skip_call
		
		lea ecx, [arguments]
		call _parser
		jmp .ignor_stosb
	.skip_call:
		stosb
	.ignor_stosb:

		jmp .while
	.end_loop:
	;----------------------------
		mov al, 0
		stosb
		
		mov edx, edi
		sub edx, dword [string]

		mov esp, ebp
		pop ebp
		ret

%undef 		string
%undef		arguments
%undef		format                                                               


;------------------------------------------------------------------
;	At the address to address of arguments in ECX take 4 byte
;	and put in EAX, increases adrress of address on 4 
;	Entry:	ECX	address on the argument
;------------------------------------------------------------------
;	Ret:	EDX	data from this address of address		
;------------------------------------------------------------------
_read_arg:
		mov edx, [ecx]
		mov edx, [edx]
		add dword [ecx], 4
		ret


;------------------------------------------------------------------
;	Check argument of '%'
;	Entry:	ESI	input string
;		EDI     string for write
;------------------------------------------------------------------
;	Ret:	EDI	the end of write argument in EDI string
;------------------------------------------------------------------
_parser:	
		call _read_arg
		lodsb
		mov ah, 'b'         	; binary
		cmp al, ah
		jne .skip_bin
		call _conv_num_bin
		ret
	.skip_bin:
	       ;------------------------
		mov ah, 'd'           	; decimal
		cmp al, ah
		jne .skip_dec
		push esi
		call _conv_num_dec
		pop esi
		ret
	.skip_dec:
		;------------------------
		mov ah, 'o'           	; octal
		cmp al, ah
		jne .skip_oct
		call _conv_num_oct
		ret
	.skip_oct:
                ;------------------------
		mov ah, 'h'       	; hexadecimal
		cmp al, ah
		jne .skip_hex
		call _conv_num_hex
		ret
	.skip_hex:
                ;------------------------
		mov ah, 's'      	; string
		cmp al, ah
		jne .skip_str
		push esi	
		call _write_string
		pop esi
		ret
	.skip_str:
		;------------------------	
		mov ah, 'c'  		; symbol
		cmp al, ah
		jne .skip_symb
		call _write_symb
		ret
	.skip_symb:
		
		ret

		

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
;	Destr:	EDI EAX EBX
;-----------------------------------------------------------------------
ascii_zero	equ	48

_conv_num_bin:
		mov ecx, 32
		
	.zero: rol edx, 1
		mov eax, edx

		and eax, 1
		cmp al, ah
		jne .skip
		loop .zero
	.skip:

		ror edx, 1
	.loop2:  rol edx, 1
		mov eax, edx

		and eax, 1
		
		add al, ascii_zero
		stosb
		loop .loop2	
		                                                                  
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
		
		cmp al, ah 
		je .skip
		add al, ascii_zero
		stosb
	.skip:

	.zero:	rol edx, 3
		mov eax, edx
		and eax, 07h
		cmp al, ah
		jne .skip_zero
		loop .zero
	.skip_zero:
		ror edx, 3
		

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

		
	.zero:	rol edx, 4
		mov eax, edx
		and eax, 0Fh
		cmp al, ah
		jne .skip
		loop .zero
	.skip:
		ror edx, 4

		
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

		mov ecx, 11
		mov ah, ascii_zero
	.zero:	lodsb
		dec ecx
		cmp al, ah
		je .zero

		dec esi
		
		rep movsb 

		ret
temp_str_dec_number	times 10 db 0
