.model tiny
.code
org 100h

start:		
                call print

                mov di, offset string
                mov al, byte ptr symbol
                mov cx, 5
		call memchr
		
		mov byte ptr [bx], 'i'
		call print

		mov ax, 4c00h
		int 21h

print		proc
		mov dx, offset string
		mov ah, 09h
		int 21h
		ret
		endp

string:		db 'love programming', 10, 13, '$'
symbol:		db 'o'

;-----------------------------------------------------
;	Search first occurrence in first CX bytes of
;	the character BL from pointer SI
;	Entry:	AL	searching character
;		CX	number of bytes to check
;		DI	pointer to the source of data
;-----------------------------------------------------
;	Ret:	BX	addr of first occurrence of the character
;			or NULL if this don't found
;-----------------------------------------------------
;	Destr:	DI CX
;-----------------------------------------------------
memchr		proc
		xor bx, bx
		cmp cx, 0
		jbe  @@end_memchr

	@@start_loop:
		scasb
		je @@assignment
		loop @@start_loop
	@@end_memchr:
		ret
	@@assignment:
		dec di
		mov bx, di
		jmp @@end_memchr 
		endp


end		start