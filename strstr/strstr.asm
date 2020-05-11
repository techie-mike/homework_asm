.model tiny
.code

end_symbol_str	equ '$'
locals @@
org 100h
start:
                call print
                call print_search

                mov di, offset string
                mov si, offset search
		call strstr


		call print_rez
		mov ax, 4c00h
		int 21h

string:		db 'Life, programs, cats...', 10, 13, '$'
search:		db 'cat$'

print		proc
		mov ah, 09h
		mov dx, offset string
		int 21h
		ret
		endp

print_rez	proc
		mov ah, 09h
		int 21h
		ret
		endp

print_search	proc
		mov ah, 09h
		mov dx, offset search
		int 21h
		mov dx, offset end_str
		int 21h
		
		ret
		endp 

end_str:	db 10, 13, '$'
;--------------------------------------------------------
;	Returns a pointer to the first occurrence of 
;	string SI in string DI, or a null pointer if 
;	string SI is not part of string DI.
;	Entry:	DI	pointer to the string
;		SI	string containing the sequence
;			of characters to match
;--------------------------------------------------------
;	Ret:	DX	A pointer to the first occurrence 
;			in DI of the entire sequence of
;			characters specified in SI, or 
;			a null pointer if the sequence 
;			is not present in DI
;--------------------------------------------------------
;	Destr:	ES BX AX
;--------------------------------------------------------
strstr		proc
		mov bx, ds
		mov es, bx
		xor dx, dx
		mov ah, end_symbol_str

		mov bx, si
		lodsb
	@@start_loop:
	        cmp byte ptr ds:[di], ah        ; if ([di] == end_symbol)
	        je @@end_loop
	        
	        scasb                           ; if ([si] == [di])
	        jne @@start_loop
	        mov dx, di
	@@check_loop:
		lodsb
		;cmp ah, byte ptr ds:[si]        ; if ([si] == end_symbol)
		cmp ah, al        ; if ([si] == end_symbol)

		je @@good_ret
		
		cmp ah, byte ptr ds:[di+1]
		je @@bad_ret	

		scasb                           ; if ([si] == [di])
		je @@check_loop
		    			
		mov di,	dx			; else
		mov si, bx
		lodsb
		xor dx, dx
		jmp @@start_loop

	@@end_loop:		
		ret
	@@good_ret:		
	        dec dx
	        jmp @@end_loop
	@@bad_ret:
		xor dx, dx
		jmp @@end_loop

		endp

end		start
		