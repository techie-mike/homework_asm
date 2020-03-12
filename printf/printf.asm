
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

;------------------------------------------------------
%include "func.asm"
;------------------------------------------------------
