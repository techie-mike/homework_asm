.model tiny
.code
locals @@

end_symbol	equ	36	; symbol '$'
org 100h

start:          call print
		mov di, offset string
		call strlen

		mov ah, 02h
		mov dl, cl
		add dl, 48
		int 21h
		
		mov ax, 4c00h
		int 21h
string:		db 'Mipt - top!$'


print		proc
		mov dx, offset string
		mov ah, 09h
		int 21h
		ret
		endp


;-----------------------------------------------------
;	Finds the length of a string (last symbol '$')
;	Entry:	DI	pointer to the string
;-----------------------------------------------------
;	Ret:	CX	the length of the string
;-----------------------------------------------------
;	Destr:	SI BL ES DX
;-----------------------------------------------------
strlen		proc
		xor cx, cx
		mov dx, ds
		mov es, dx

		mov al, end_symbol	
	@@start_loop:                
		scasb
		je @@end_loop
		loop @@start_loop
	@@end_loop:
		not cx
		inc cx
                ret
		endp

end		start
		          