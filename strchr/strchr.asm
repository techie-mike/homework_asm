.model tiny
.code
locals @@

end_symbol	equ	36	; symbol '$'
org 100h

start:          call print
		mov di, offset string
		mov al, '-'
		call strchr

		mov byte ptr [di], '='
		call print
		
		mov ax, 4c00h
		int 21h
string:		db 'Mipt - top!', 10, 13,'$'


print		proc
		mov dx, offset string
		mov ah, 09h
		int 21h
		ret
		endp
;-----------------------------------------------------
;	Finds the first occurrence of a character 
;	of a string (last symbol '$')
;	Entry:	DI	pointer to the string
;		AL	searching character
;-----------------------------------------------------
;	Ret:	DI	the first occurrence of a character
;			or '0' if don't found
;-----------------------------------------------------
;	Destr:	ES BX
;-----------------------------------------------------
strchr		proc
		mov bx, ds
		mov es, bx
 
		mov ah, end_symbol	
	@@start_loop:                
		scasb
		je @@go_ret
		
		cmp byte ptr [di], ah
		je @@end_loop
		
		jmp @@start_loop
	@@end_loop:
		xor di, di
		ret
	@@go_ret:
		dec di
                ret
		endp

end		start
		          