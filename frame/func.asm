.getch		macro
		nop
		xor ah, ah
		int 16h
		nop
		endm
;------------------------------------

.shadows	macro
		mov byte ptr es:[bx], 01010000b
		endm

color_shadows	equ	01000000b	

color_backgrownd	equ	00110000b