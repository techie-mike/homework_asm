include func.asm
;--------------------------------------------------------
;	Calculation address position on screen of top
;	left angle starting out from ES
;	Entry:	CH	number of lines in frame
;		CL	number of column in frame
;--------------------------------------------------------
;	Destr:	AX 
;--------------------------------------------------------
;	Ret:	BX	address position on screen of top
;			left angle starting out from reg ES
;--------------------------------------------------------
	calculation_bx_pointer proc
		mov ax, 80
		mul ch

		mov bx, ax
		xor ax, ax
		mov al, cl
		add bx, ax

		shl bx, 1

		ret
	calculation_bx_pointer endp


;--------------------------------------------------------
;	Draw frame
;	Entry:	CH	vertiacal position top left angle
;			of frame
;		CL      vertiacal position top left angle
;			of frame
;		DH	height of frame (include bottom line)
;		DL	width of frame (include right column)
;
;		BX	addr of cusrsor on screen
;		ES	addr of starting video memory
;			of console screen
;--------------------------------------------------------
	draw_frame proc
		xor ah, ah	; byte for height
	@@big_for:
		xor al, al	; byte for width

		cmp ah, dh
		ja @@end_big_for

	@@small_for:
		cmp al, dl
		ja @@end_small_for

		call create_frame
		.draw_background
		add bx, 2
		inc al

		jmp @@small_for

	@@end_small_for:
		call newline
		jmp @@big_for

	@@end_big_for:
		sub bx, 160
		mov al, dl
		xor ah, ah
		add bx, ax
		add bx, ax
		ret
	draw_frame endp


;--------------------------------------------------------
;	Go to newline of frame
;	Entry:	BX	addr of cusrsor on screen
;		DH	height of frame (include bottom line)
;		DL	width of frame (include right column)
;--------------------------------------------------------
;	Ret:	BX	addr of cursor on screen with + 1
;			vertiacal line and gorizontal position
;			of the top left angle of frame
;--------------------------------------------------------
	newline	proc
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
;	Draw symbols on screen of frame if this edge of frame
;	Entry:	AH 	vertiacal position cursor from 
;			top left angle of frame
;		AL 	gorizontal position cursor from 
;			top left angle of frame
;--------------------------------------------------------
	create_frame proc
		cmp al, 0
		je @@vertical_frame

		cmp al, dl
		je @@vertical_frame

		cmp ah, dh
		je @@gorizontal_frame

		cmp ah, 0
		je @@gorizontal_frame

		
	@@end_create:
		ret

	@@vertical_frame:
		mov byte ptr es:[bx], 186
		jmp @@end_create

	@@gorizontal_frame:
		mov byte ptr es:[bx], 205
		jmp @@end_create
	create_frame endp


;---------------------------------------------------------------------
;	Draw all shadows of frame
;	Entry:	DH	vertiacal position of right buttom angle frame
;			from position left top angle
;		DL	gorizontal position of right buttom angle frame
;			position left top angle
;		ES	address of starting video memory
;			of screen
;		BX	addr of cusrsor on screen
;---------------------------------------------------------------------
;	Destr:	AX
;---------------------------------------------------------------------
	draw_shadows proc
		mov al, 160
		mul dh
		sub bx, ax
		add bx, 163
		mov ah, 0

	@@loop_side:
		cmp ah, dh
		ja @@end_loop_side

		mov byte ptr es:[bx], color_shadows
		add bx, 2
		mov byte ptr es:[bx], color_shadows

		add bx, 158

		inc ah
		jmp @@loop_side

 	@@end_loop_side:
		sub bx, 160 + 2

		mov al, dl
		add al, dl
		mov ah, 0
		sub bx, ax
		add bx, 4

		mov al, 2
	@@loop_bottom:
		cmp al, dl
		ja @@end_loop_bottom
		mov byte ptr es:[bx], color_shadows
		add bx, 2
		inc al
		jmp @@loop_bottom

	@@end_loop_bottom:
		sub bx, 160 + 3
		;mov byte ptr es:[bx+1], 52
		ret
	draw_shadows endp


;--------------------------------------------------------
;	Draw a angle of frame
;	Entry:	BX	adrr of cusrsor on screen
;		ES	address of starting video memory
;			of screen
;--------------------------------------------------------
;	Destr:	BX CX
;--------------------------------------------------------
	draw_angle proc
		;mov cx, dx
		mov byte ptr es:[bx], 188	; bottom right angle

		.offset_height
		mov byte ptr es:[bx], 187	; top right angle
		add bx, ax

		.offset_width
		mov byte ptr es:[bx], 200	; bottom left angle

		.offset_height
		mov byte ptr es:[bx], 201	; top left angle
		ret
	draw_angle endp


;--------------------------------------------------------
