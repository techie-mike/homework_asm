;----------------------------------------------------------
;	Entry system (c) Kaskov, 2020
;	Only for education (breaking)
;	Only for DOS
;----------------------------------------------------------
.model tiny
.code
org 100h

locals @@
	
start:
		push cs cs
		pop  es ds
	                 
		call main
		call exit

;----------------------------------------------------------

NL			equ 0dh, 0ah
EOL			equ '$'

welcome_msg 		db  'Enter password:  ', EOL
checking_msg 		db  'Checking...',NL, EOL
check_failed_msg	db  'Password check failed! ',NL, EOL
admin_rights_msg 	db  'Access is allowed.  ', NL, EOL
                                 
cr_lf			db  NL, EOL

;true_password		db "rrrtttee"


;----------------------------------------------------------                         
main		proc
		mov dx, offset welcome_msg
		call printStr
		
                mov di, offset password
		call getStr
		
		mov dx, offset checking_msg
		call printStr

		
;----------------------------------------------------------
;	Processing scecifically inside the code
;	Destr:	CX
;	Ret:	DI	address to true point
;----------------------------------------------------------
		mov si, offset password
		mov cx, 8
		mov di, 0
		xor ax, ax
	@@while: 
		lodsb
		add di, ax
		rol di, 3
		loop @@while

		mov ax, di
		and ax, 0ffh
		
		mov bl, 10
		div bl

		mov bx, ds:[offset @@base_l + 1]
		mov cl, byte ptr [bx]

		add cl, ah
		mov ds:[bx], cl		
		
		nop
		
@@base_l:	jmp @@l5
		nop


;----------------------------------------------------------		
		jmp @@l0
password	db 8 dup ('$')
	
;		nop			; it's help for you :)

	@@l00:	jmp @@password_ok   	; true exit
	@@l0:	jmp @@l2
	@@l1:	jmp @@l4
	@@l2:	jmp @@l6
	@@l3:	jmp @@l1
	@@l4:	jmp @@password_fail	; false exit
	@@l5:	jmp @@l7
	@@l6:	jmp @@l9 
	@@l7:   jmp @@l3
	@@l8:	jmp @@l10		; <------ correct entry
	@@l9:   jmp @@l5
	@@l10:	jmp @@l00

	
;----------------------------------------------------------
;	Check funcion
;----------------------------------------------------------
	@@password_ok:
		mov cl, 11h
		cmp al, cl
		jne @@password_fail
		
		mov dx, offset admin_rights_msg
		call printStr
		ret

	@@password_fail:
		mov dx, offset check_failed_msg
		call printStr
		ret
		endp


;----------------------------------------------------------
;	Write symbol from consol to the string while don't 
;	see symbol 0dh
;	Entry:	DI	space string
;----------------------------------------------------------
;	Ret:	DI	end of writing string
;---------------------------------------------------------- 
getStr		proc

		@@write_string:
		mov ah, 01h
		int 21h

		
		cmp al, 0dh
		je @@exit_string

		stosb

		jmp @@write_string
	@@exit_string:
		
		ret		
		endp


;----------------------------------------------------------
;	Write string in console
;	Entry:	DX	address of a string with end 
;			symbol '$'
;----------------------------------------------------------
printStr	proc
		mov ah, 09h
		int 21h
		ret
		endp


;----------------------------------------------------------
;	Exit from program
;----------------------------------------------------------
exit		proc
		mov ax, 4c00h
		int 21h
		ret
		endp

;----------------------------------------------------------
end		start