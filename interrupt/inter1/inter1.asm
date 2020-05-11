.model tiny
.code
org 100h
start:
		mov ah, 31h
		mov dx, offset TheEnd
		shr dx, 4
	;	inc dx
		int 21h
TheEnd:
end start		