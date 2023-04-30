;enter - none
;exit - timer for 10 seconds
proc timer_for_10_Sec
	doPush ax,es,cx
    taketime
FirstTick: 
	cmp ax, [Clock]
	je FirstTick
	; print start message
	
	; count 10 sec
	mov cx,182 ;182*0.055=10 seconds
DelayLoop:
	mov ax,[Clock]
Tick:
	cmp ax,[Clock]
	je Tick
	loop DelayLoop
	
	doPop cx,es,ax
ret
endp timer_for_10_Sec
