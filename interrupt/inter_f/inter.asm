.model tiny
.code
org 100h
locals @@
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
                push ax di si es
                mov di, 0b800h
                mov es, di

                push bx cx dx
                ;--------------------------------------------
                mov ch, 10	; vertical position
		mov cl, 5	; gorizontal position

		mov dh, 15	; end vertical position
		mov dl, 60	; end gorizontal position
		sub dh, ch
		sub dl, cl

		call calculation_bx_pointer
		call draw_frame
		call draw_shadows
		call draw_angle
		;---------------------------------------------	

		call calc_point
		mov si, di
		in al, 60h
		mov ah, 4eh
        
	 	;---------------------------------------------	
		mov di, offset free_str
		xor ah, ah
		call write_num
		mov bx, video_segment
		mov es, bx

		mov di, si	
		mov si, offset free_str
		mov dl, byte ptr ds:[si]
		mov byte ptr es:[di], dl


		movsb
		inc di
		movsb
		inc di
		movsb

		sub si, 3
		sub di, 5
		;--------------------------------------------
		
		pop dx cx bx
	     
                pop es si di ax
		db 0eah

old09h		dw 0
		dw 0

                iret

		endp

free_str:	db '                 '
;-----------------------------------------------
include frame.asm
;-----------------------------------------------



;-----------------------------------------------
;	Calculation point on screen for write
;	symbol from keyboard
;-----------------------------------------------
;	Entry:	
;-----------------------------------------------
;	Ret:	DI	pointer on screen 
;			(from video segment)
;-----------------------------------------------
;	Destr:	
;-----------------------------------------------
calc_point	proc
		mov al, 160
		mul ch
		add ax, 160
		mov di, ax
		xor ax, ax
		mov al, cl
		add ax, 1
		shl ax, 1
		add di, ax
		
		ret
		endp
;------------------------------------------------
;	Convert number in string with point DI
;	Entry:	DI	point on space string
;		AX	number
;------------------------------------------------
;	Destr:	SI DI
;------------------------------------------------
write_num 	proc
		;mov si, ds
		;mov es, si

		push cx
		push dx
		mov cx, 2	; 2 - because 2 symbol in hex bytes
	@@la0:
		rol al, 4
		mov dl, al
		and dl, 0Fh
		
		cmp dl, 9
		jbe @@la1
		add dl, 7
	@@la1:	add dl, 30h

		;push ax
		;mov ah, 02h
		;int 21h
		;pop ax

		mov ds:[di], dl
		inc di
		
		loop @@la0
		
		
		mov dl, 'h'
		mov ds:[di], dl
		inc di

		pop dx
		pop cx
		ret
		endp						
theend:
end		start