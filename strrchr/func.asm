end_symbol	equ	36	; symbol '$'


;-----------------------------------------------------
;	Finds the length of a string (last symbol '$')
;	Entry:	DI	pointer to the string
;-----------------------------------------------------
;	Ret:	CX	the length of the string
;-----------------------------------------------------
;	Destr:	SI BL ES AL DX
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
;	Destr:	DI CX DX
;-----------------------------------------------------
memchr		proc
		mov dx, ds
		mov es, dx

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
