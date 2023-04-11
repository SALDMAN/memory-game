
; receives: list of registers
; pushing the given registers
doPush macro r1,r2,r3,r4,r5,r6,r7,r8,r9
        irp register,<r9,r8,r7,r6,r5,r4,r3,r2,r1>
                ifnb <register>
                        push register
                endif
        endm
endm

; receives: list of registers
; popping the given registers
doPop macro r1,r2,r3,r4,r5,r6,r7,r8,r9
        irp register,<r9,r8,r7,r6,r5,r4,r3,r2,r1>
                ifnb <register>
                        pop register
                endif
        endm
endm

;the macro stops the program
wait_for_key_pressed macro
mov ah,00h
int 16h
endm

;the macro returns to the text mode
return_to_text_mode macro
mov ax,3
int 10h
endm

;the macro moves to graphic mode
MoveGrafic macro
	mov ax, 13h
	int 10h
endm

;this macro open the mic and get accsses to the mic
OpenMic macro
	in al, 61h
	or al, 00000011b
	out 61h, al
	
	mov al, 0B6h
	out 43h, al
endm

;the macro close the mic
CloseMic macro
	in al, 61h
	and al, 11111100b
	out 61h, al
endm

; insert to a cuent time
taketime macro
	mov ax, 40h
	mov es, ax
	mov ax, [Clock]
endm


