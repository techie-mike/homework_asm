.model tiny
.code
org 100h

start:		
		call print
		mov si, offset string1
		mov di, offset string2
		mov cx, 2
		call memcmp
		
		mov ah, 02h
		mov dl, al
		add dl, 61
		int 21h	

		mov ax, 4c00h
		int 21h

string1:	db 'mipt', 10, 13, '$'
string2:	db 'mIPT', 10, 13, '$'
;-----------------------------------------------
print		proc
		mov dx, offset string1
		mov ah, 09h
		int 21h

		mov dx, offset string2
		mov ah, 09h
		int 21h
		ret
		endp

;-----------------------------------------------------
;	Compare two blocks of memory
;	Entry:	CX	number of bytes to compare
;		SI	pointer to the first  block memory
;		DI	pointer to the second block memory
;-----------------------------------------------------
;	Ret:	AL	 0 if equal
;			>0 if first block has a greater then second
;			<0 if first block has a lower then second
;-----------------------------------------------------
;	Destr:	SI DI CX AX ES
;-----------------------------------------------------
memcmp		proc
		mov ax, ds
		mov es, ax
		cmp cx, 0
		jbe  @@end_memcmp

	@@start_loop:
		cmpsb
		jne @@check_cmp
		loop @@start_loop
		xor al, al
	@@end_memcmp:
		ret

	@@check_cmp:
		ja @@above
		mov al, -1
		jmp @@end_memcmp
	@@above:
		mov al, 1
		jmp @@end_memcmp
		endp

end		start