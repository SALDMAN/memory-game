;enter- numbers of clock hours minutses seconds multi seconds
;exit - timer of 30 seconds
proc timer
	doPush ax,bx,cx,es
    taketime
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

;enter - numbers of clock multi seconds seconds minutses hours
;exit - timer for 10 seconds
proc timer2
	doPush ax,es,cx
    taketime
FirstTick2: 
	cmp ax, [Clock]
	je FirstTick2
	; print start message
	
	; count 10 sec
	mov cx,182 ;182*0.055=10 seconds
DelayLoop2:
	mov ax,[Clock]
Tick2:
	cmp ax,[Clock]
	je Tick2
	loop DelayLoop2
	
	doPop cx,es,ax
ret
endp timer2


