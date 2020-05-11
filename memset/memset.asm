.model tiny
.code
org 100h
local @@

start:
		call print
		mov bx, offset string + 1
		mov al, 50
		mov cx, 5

		call memset	

	        call print

		mov ax, 4c00h
		int 21h

string:		db 'hello, my friend', 10, 13, '$'

print		proc
		mov dx, offset string
		mov ah, 09h
		int 21h
		ret
		endp

;--------------------------------------------------------
;	Sets the first num bytes of the block 
;	of memory pointed by ptr to the specified value	
;
;	Entry:	BX	memory point
;		CX	num bytes for filling
;		AL	value for filling
;--------------------------------------------------------
;	Destr:	CX BX
;--------------------------------------------------------
memset	proc
		cmp cx, 0
		jbe @@end_memset

	@@start_loop:
		mov [bx], al
		inc bx
		loop @@start_loop
	@@end_memset:
		ret
		endp


end		start