
; Written on nasm + alink + WinAPI

; nasm    "1-Nasm+Alink.asm" -f obj -l "1-Nasm+Alink.lst"
; alink   "1-Nasm+Alink.obj" -oPE -c -subsys console
; ndisasm "1-Nasm+Alink.exe" -b 32 -e 512 > "1-Nasm+Alink.disasm"

extern GetStdHandle
import GetStdHandle  kernel32.dll

extern WriteConsoleA
import WriteConsoleA kernel32.dll

extern ExitProcess
import ExitProcess   kernel32.dll

extern MessageBoxA
import MessageBoxA   user32.dll

section .data use32

str_printf	times 1024 db 0

example_string db "buy Intel Processor", 0

input_str	db "Write decimal number 45: %d", 10, 	\
		 "binary number 1023: %b",10,  		\
		 "hexademical number 127: %h", 10,	\
		 "octal number 127: %o", 10,		\
		 "advertising integration: %s", 10,	\
		 "a symbol of the issue %c", 0          
		

;example_string	db "choto dolgo polychilos", 0

;input_str	db "DEBAG:Pechatay, Vasya chislo 45: %d and 1023 %b and string: %s and symol %c. Wrode workaet",   \
;		"a esli 127: %o  127 %h", 10,0


section .code use32

..start:        
		push '?'
		push example_string
		push 127

		push 127
		push 1023
        	push 45
		push dword input_str

		call printf

		call exit


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

		
;------------------------------------------------------
%include "func.asm"
;------------------------------------------------------
