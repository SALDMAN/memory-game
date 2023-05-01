include macro.asm
IDEAL
JUMPS
MODEL small
STACK 100h
DATASEG
    include "var.asm"
CODESEG
    include "words.asm"
	include "screen.asm"
	include "time.asm"
	include "music.asm"
start:
	mov ax, @data
	mov ds, ax
	mov es,ax
	MoveGrafic ;move to graphic mode
	
open_screen:
	call mainscreen;call to the first
keep_open_screen:
    ;wait in the open screen until the player type p or i
    mov ah,7h
    int 21h
	;check if he want the instraction screen
    cmp al,'i'
    je instraction_screen
	cmp al,'I'
    je instraction_screen
	;check if he want to start the game
    cmp al,'p'
	je play
	cmp al,'P'
    je play
	;check if he want to quit
	cmp al,1bh
    je exit
	jmp keep_open_screen
	
instraction_screen:
    call instractionscreen
	jmp keep_instraction_screen

keep_instraction_screen:
    ;wait in the instraction screen until the player type esc
	mov ah,7h
	int 21h
	cmp al,1bh
    je open_screen
    jmp keep_instraction_screen
loose:
    MoveGrafic
    call losescreen
keep_lose_Screen:
    ;wait in the loose screen until the player type enter
	mov ah,7h
	int 21h
	cmp al,0dh
    je open_screen
    jmp keep_lose_Screen	
play:
    ;clear the screen 
	MoveGrafic
	;call call_for_print
	mov dx, offset massage
	mov ah,9h
	int 21h
	;get a random word
    call generateword
	cmp [wrong],1
	je play
	
	
	mov dx, offset StartMessage2
	mov ah,9h
	int 21h
	
	;start to call to the timer that show the word for 10 seconds
	call timer_for_10_Sec
	
	
	MoveGrafic
	
	; print start message
	mov dx, offset StartMessage
	mov ah,9h
	int 21h
	
	;start a timer for 30 seconds
	mov [pressEnter],0
	takeTime
	mov [oldTime], ax
	mov [ticks], 546;546*0.055=30 seconds
	jmp userInput

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
    
	call get_input
	mov [wrong],0
	cmp [pressEnter], 2	; press esc
	je exit
	cmp [pressEnter], 1 ; press enter
	jne userInput
	;check the word
	call check_word
	cmp [correct], 1
	je  not_gussed
	jmp currect

not_gussed:
    ;if he did not gussed he can do it again until the timer will be 0
    mov [wrong],1
	mov [pressEnter],0
	mov [count],1
	jmp userInput
currect:
    ;check if he got wrong somewhere
 	cmp [count],0
	je check
	;if he had failed the combo reset to zero
	mov [combo],0
	mov [count],0
    jmp play
check:
    ;check if he did gussed 5 words in a row
	inc [combo]
	cmp [combo],5
	je suprise
    jmp play
suprise:
    ;start the music
    call music
	;reset the combo back to 0
	mov [combo],0
	jmp play
exit:
	return_to_text_mode
	mov ax,4c00h
	int 21h
	END start