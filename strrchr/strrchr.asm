.model tiny
.code
locals @@
org 100h

start:		
		mov dx, offset string
		call print
		
		mov di, offset string
		mov al, 'p'
		call strrchr
                
                mov byte ptr ds:[di], 32

		mov dx, offset string
		call print
		mov ax, 4c00h
		int 21h

print		proc
		mov dx, offset string
		mov ah, 09h
		int 21h
		ret
		endp


;-----------------------------------------------------
;	Finds the first occurrence of a character 
;	of end a string (last symbol '$')
;	Entry:	DI	pointer to the string
;		AL	searching character
;-----------------------------------------------------
;	Ret:	DI	the first occurrence of a character
;			or '0' if don't found
;-----------------------------------------------------
;	Destr:	ES BX
;-----------------------------------------------------
strrchr 	proc
                mov ah, al
		call strlen
		
		mov al, ah
		std
		;	mov di, offset string
		;	add di, cx
		dec di	
		call memchr
		cld
		add di, 2
		
		ret
		endp

string:		db 'pppp MIpT   !', 10, 13, '$'

include		func.asm

end		start