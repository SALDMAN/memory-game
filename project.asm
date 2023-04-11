include macro.asm
IDEAL
MODEL small
STACK 100h
DATASEG
    include "var.asm"
CODESEG
    include "words.asm"
	include "tmonot.asm"
	include "time.asm"
start:
	mov ax, @data
	mov ds, ax
	mov es,ax
	MoveGrafic ;move to graphic mode
open_screen:
	call mainscreen;call to the first
    mov ah,7h
    int 21h
    cmp al,0dh
    je instraction_screen
    cmp al,'p'
	je play
	cmp al,'P'
    je play
	jmp start
instraction_screen:
     call instractionscreen
	 mov ah,7h
	 int 21h
	 cmp al,1bh
	 je open_screen
	 jmp instraction_screen
play:
    ;clear the screen 
	MoveGrafic
	;get a random word
    call generateword
	cmp [wrong],1
	je play
	
	mov dx, offset StartMessage2
	mov ah,9h
	int 21h
	
	;start to call to the timer that show the word for 10 seconds
	call timer2
	
	
	MoveGrafic
	
	; print start message
	mov dx, offset StartMessage
	mov ah,9h
	int 21h
	
	
	mov [pressEnter],0
	takeTime
	mov [oldTime], ax
	mov [ticks], 546;546*0.055=30 seconds
userInput:
	
	takeTime
	cmp ax, [oldTime]
	je input
	mov [oldTime], ax
	dec [ticks]
	jnz input
	jmp loose
	;checks if the time has reched 0
	
input:
    MoveGrafic
	call get_input
	cmp [pressEnter], 2	; press esc
	je exit
	cmp [pressEnter], 1 ; press enter
	jne userInput
	
	call check_word
	cmp [correct], 1
	je userInput
	jmp play
loose:
    call losescreen
exit:
    wait_for_key_pressed 
    return_to_text_mode
	mov ax,4c00h
	int 21h
	END start