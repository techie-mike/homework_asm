.model tiny
.code
org 100h

include func.asm


;--------------------------------------------------------
video_segment equ 0b800h  

;----------------- start main program ------------------- ;
start:
		mov ch, 10	; vertical position
		mov cl, 5	; gorizontal position
		
		call calculation_bx_pointer 		
	
		mov dh, 15	; end vertical position
		mov dl, 40	; end gorizontal position
		sub dh, ch
		sub dl, cl

		call draw_frame
		call draw_shadows
		call draw_angle
		
		.getch
		mov ax, 4c00h
		int 21h
;--------------- end main program ----------------------- ;	
		
	calculation_bx_pointer proc
		mov ax, video_segment
		mov es, ax

		mov ax, 80
		mul ch
		
		mov bx, ax
		mov ax, 0
		mov al, cl
		add bx, ax
		
		mov ax, 2
		mul bx
		mov bx, ax
		add bx, 0

		ret
	calculation_bx_pointer endp
;--------------------------------------------------------
		
	draw_frame proc
		mov ah, 0	; byte for height
	big_for:
		mov al, 0	; byte for width
	
		cmp ah, dh
		ja end_big_for
			
	small_for:
		cmp al, dl
		ja end_small_for
			
		call create_frame
		call draw_background		
		add bx, 2	
		inc al

		jmp small_for

	end_small_for:
		call newline
		jmp big_for

	end_big_for:
		sub bx, 160
		mov al, dl
		mov ah, 0
		add bx, ax
		add bx, ax
		ret
	draw_frame endp
;--------------------------------------------------------		
	
	newline proc
		mov al, dh
		mov dh, 0
		
		sub bx, dx
		sub bx, dx
		sub bx, 2

		mov dh, al
		add bx, 80 * 2
		inc ah
		ret
	newline endp
;--------------------------------------------------------	
	create_frame proc
		cmp al, 0
		je vertical_frame
		
		cmp al, dl
		je vertical_frame

		cmp ah, dh
		je gorizontal_frame

		cmp ah, 0
		je gorizontal_frame

	end_create:
		ret

	vertical_frame:
		mov byte ptr es:[bx], 186
		jmp end_create
			
	gorizontal_frame:
		mov byte ptr es:[bx], 205
		jmp end_create
	create_frame endp
;--------------------------------------------------------
;	Draw all shadows of frame
;	Entry:	DH - vertiacal position of right buttom angle frame
;		DL - gorizontal position of right buttom angle frame
	draw_shadows proc
		mov al, 160
		mul dh
		sub bx, ax
		add bx, 163
		mov ah, 0
	
	loop_draw_shadows_side:
		cmp ah, dh
		ja end_loop_draw_shadows_side
					; fucking copying

		mov byte ptr es:[bx], color_shadows
		add bx, 2
		mov byte ptr es:[bx], color_shadows

		add bx, 158
		
		inc ah
		jmp loop_draw_shadows_side

 	end_loop_draw_shadows_side:
		sub bx, 160 + 2
		
		mov al, dl
		add al, dl
		mov ah, 0
		sub bx, ax
		add bx, 4
		
		mov al, 2
	loop_draw_shadows_bottom:
		cmp al, dl
		ja end_loop_shadows_bottom 
		mov byte ptr es:[bx], color_shadows
		add bx, 2
		inc al
		jmp loop_draw_shadows_bottom

	end_loop_shadows_bottom:
		sub bx, 160 + 3		
		ret
	draw_shadows endp
;--------------------------------------------------------

	draw_background proc
		inc bx
		mov byte ptr es:[bx], color_backgrownd
		dec bx
		ret
	draw_background endp	

;--------------------------------------------------------
;	Draw a angle of frame
;	Entry:	BX - adrr of cusrsor on screen
;--------------------------------------------------------
;	Destr:	BX CX
;--------------------------------------------------------
	draw_angle proc
		mov cx, dx
		mov byte ptr es:[bx], 188
		
		call offset_for_height
		mov byte ptr es:[bx], 187		
		add bx, ax

		call offset_for_width
		mov byte ptr es:[bx], 200
		
		call offset_for_height
		mov byte ptr es:[bx], 201		
		ret
	draw_angle endp
;--------------------------------------------------------
	
	offset_for_height proc
		mov ax, 160
		mul ch
		sub bx, ax
		ret
	offset_for_height endp
;--------------------------------------------------------
		
	offset_for_width proc
		mov al, cl
		mov ah, 0
		sub bx, ax
		sub bx, ax
		ret
	offset_for_width endp
;--------------------------------------------------------
end	start
