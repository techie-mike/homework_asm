color_shadows		equ	00010000b
video_segment		equ	0b800h
color_background	equ	00110000b


;--------------------------------------------------------
;	Stop a program befor presing a key
;	Destr:	AX
;--------------------------------------------------------
.getch		macro
		nop
		xor ah, ah
		int 16h
		nop
		endm


;--------------------------------------------------------
;	Draw background of position cursor
;	Entry:	BX	address of cursor on screen 
;			startiong out from 
;--------------------------------------------------------
.draw_background	macro
		inc bx
		mov byte ptr es:[bx], color_background
		dec bx
		endm


;--------------------------------------------------------
;	Move the cursor form the top line to bottom line
;	with old gorizontal position
;	Entry:	BX	cursor position
;		CH	number of lines in frame
;--------------------------------------------------------
;	Ret:	AX	number symbols between
;			top and bottom line
;		BX	
;--------------------------------------------------------
.offset_height	macro
		mov al, 160
		mul dh
		sub bx, ax
		endm


;--------------------------------------------------------
;	Move the cursor form the right side to left side
;	with old gorizontal position
;	Entry:	BX	cursor position
;		CH	number of lines in frame
;--------------------------------------------------------
;	Ret:	AX	number symbols between
;			left and right side
;--------------------------------------------------------
.offset_width	macro
		mov al, dl
		mov ah, 0
		shl ax, 1
		sub bx, ax
		endm
