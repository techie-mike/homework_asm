.model tiny
.code

locals @@
org 100h
start:		call print
		mov di, offset string1 + 13
		mov si, offset string2
		call strcpy
		
		mov di, offset string1

		call print

		mov ax, 4c00h
		int 21h

string1:	db 'I want to go win10   $'
string2:	db 'linux!$'

print		proc
		mov dx, offset string1
		mov ah, 09h
		int 21h
		ret
		endp


;--------------------------------------------------------------
;	Copies the string pointed by SI into the array pointed 
;	by DI, including the terminating last character ($)
;	Entry:	SI	pointer to the copies string
;		DI	pointer to the copy space
;--------------------------------------------------------------
;	Ret:	DI	pointer to the copy space
;--------------------------------------------------------------
;	Destr:	BX ES AL
;--------------------------------------------------------------
strcpy		proc
		mov bx, ds
		mov es, bx

		mov al, '$'
                mov bx, di
	@@start_loop:
                movsb
                cmp al, byte ptr ds:[si]
                jne @@start_loop

                mov di, bx

                ret
		endp

end 		start