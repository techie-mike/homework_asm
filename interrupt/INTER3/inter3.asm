.model tiny
.code
org 100h
start:		
		xor ax, ax
		mov es, ax
		
		mov bx, 8*4 
		mov ax, es:[bx]
		mov old09h, ax
		mov ax, es:[bx+2]
		mov old09h + 2, ax

		
		mov ax, cs

		cli		; in this place disable interrupt
		
		mov word ptr es:[bx], offset new09h
		mov word ptr es:[bx+2], ax

		sti		; return flag interrpur


		mov ah, 31h
		mov dx, offset theend
		shr dx, 4
		inc dx
		int 21h

new09h		proc
                push ax di es
                mov di, 0b800h
                mov es, di
                mov di, (5*80 + 38) * 2
                
                in al, 60h
                ;mov al, cl
                mov ah, 4eh

                stosw
	comment *
                in al, 61h
                mov ah, al
                or al, 80h
                out 61h, al
                mov al, ah
                out 61h, al
	
                mov al, 20h
                out 20h, al
        *         
                pop es di ax
		db 0eah
old09h		dw 0
		dw 0

                iret

		endp

				
theend:
end		start