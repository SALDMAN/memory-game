;enter - none
;exit - timer for 10 seconds
proc timer_for_10_Sec
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
endp timer_for_10_Sec


