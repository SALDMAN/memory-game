;enter-none
;exit - a music until the player taped s
proc music
speek:
    ;clean the screen
    MoveGrafic
	call extra_screen
    mov ah,7h
	int 21h
    cmp al,'P'
	je continue
	cmp al,'p'
	je continue
	jmp speek
continue:
	; open speaker
	OpenMic
	; send control word to change frequency
    mov al,0b6h
    out 43h,al
; play frequency 432Hz 
    mov ax,[note]
    out 42h,al	; sending lower byte
    mov al,ah
    out 42h,al	; sending upper byte
	;wait for key "s"
    mov ah,7h
    int 21h
    cmp al,'S'
	je close
	cmp al,'s'
	je close
	jmp continue
close:
; close the speaker
   CloseMic
   ret
endp music


