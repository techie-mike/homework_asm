.model tiny
.code
org 100h
local @@

start:		
		call print

                mov si, offset string2
                mov di, offset string1 + 9
                mov cx, 8
		call memcpy

		call print

		mov ax, 4c00h
		int 21h

print		proc
		mov dx, offset string1
		mov ah, 09h
		int 21h
		ret
		endp

string1:		db 'Hello my nerves     ', 10, 13, '$'
string2:		db 'insomnia', '$'

;-----------------------------------------------------
;	Copy first CX bytes from pointer SI to pointer DI
;	Entry:	CX	number of bytes to copy
;		SI	pointer to the source of data
;		DI	pointer to the destination
;-----------------------------------------------------
;	Destr:	SI DI CX BL
;-----------------------------------------------------
memcpy		proc
		cmp cx, 0
		jbe  @@end_memcpy

		rep movsb
	@@end_memcpy:
		ret
		endp
		
end		start		