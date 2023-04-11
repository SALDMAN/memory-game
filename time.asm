;enter- numbers of clock hours minutses seconds multi seconds
;exit - timer of 30 seconds
proc timer
	doPush ax,bx,cx,es
    mov ax, 40h
	mov es, ax
	mov ax, [Clock]
FirstTick: 
	cmp ax, [Clock]
	je FirstTick
	
	; count 30 sec
	mov cx,546;546*0.055=30 seconds
DelayLoop:
	mov ax,[Clock]
Tick:
    call get_input
	cmp [pressEnter], 1
	jne cont
	call check_word
cont:
	cmp ax,[Clock]
	loop DelayLoop
	doPop es, cx,bx,ax
	ret
endp timer

proc 	printNumber
; enter – number in al
; exit – printing the numbers digit by digit
         doPush ax,bx,dx
	    mov bx,offset divisorTable
nextDigit:
    	xor ah,ah         		
    	div [byte ptr bx]   	;al = quotient, ah = remainder
    	add al,'0'
    	call printCharacter  	;Display the quotient
    	mov al,ah          		;ah = remainder
	    add bx,1            		;bx = address of next divisor
    	cmp [byte ptr bx],0 	;Have all divisors been done?
        jne nextDigit
    	doPop dx,bx,ax
	    ret
endp 	printNumber

proc printCharacter
; enter – character in al
; exit – printing the character
	doPush ax,dx
	mov ah,2
	mov dl, al
	int 21h
	doPop dx,ax
	ret
endp printCharacter

; 1secons only
proc timer2
	doPush ax,es,cx
    mov ax, 40h
	mov es, ax
	mov ax, [Clock]
FirstTick2: 
	cmp ax, [Clock]
	je FirstTick2
	; print start message
	
	; count 10 sec
	mov cx,182 ;182x0.055=10+ seconds
DelayLoop2:
	mov ax,[Clock]
Tick2:
	cmp ax,[Clock]
	je Tick2
	loop DelayLoop2
	
	doPop cx,es,ax
ret
endp timer2


