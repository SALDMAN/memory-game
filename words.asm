;enter- none
;exit-  random word and it's length
proc generateword
    dopush ax,es,bx,dx
    mov [wrong],0 
	mov ax, 40h
	mov es, ax;move the es to the clock
	xor bx,bx;restart bx
RandLoop:
	mov bx, [Clock] 		; read timer counter
	mov bh, [byte cs:bx] 	; read one byte from memory
	xor bl, bh 			    ; xor memory and counter
	and bl, 00001111b 		; leave result between 0-15
	
	;mov si, offset seletedWordLen
	;add si,bx
	;mov al, [si]
	;mov [seletedWordLen],al
    shl bx,1
	xor bh, bh
	cmp bx,15
	ja again;if the random number is above 15
	call get_length;to get the length of the random word 	
	call print_Word
	mov ah,9h
	int 21h	;output the word
	jmp endr
again:
    mov [wrong],1
	jmp endr
endr:
	dopop dx,bx,es,ax
	ret
endp generateword
;enter - the number of the random word
;exit  - the length of the random word
proc get_length
    mov [seletedWordLen],0
    cmp bl,0
	je case1
	cmp bl,1
	je case2
	cmp bl,2
	je case3
	cmp bl,3
	je case4
	cmp bl,4
	je case5
	cmp bl,5
	je case6
	cmp bl,6
	je case7
	cmp bl,7
	je case8
	cmp bl,8
	je case9
	cmp bl,9
	je case10
	jmp elsee
case1:
     mov [seletedWordLen],11
	 mov [choose],1
	 jmp endl
case2:
      mov [seletedWordLen],9
	  mov [choose],2
	  jmp endl
case3:
      mov [seletedWordLen],10
	  mov [choose],3
	  jmp endl
case4:
      mov [seletedWordLen],10
	  mov [choose],4
	  jmp endl
case5:
      mov [seletedWordLen],10
	  mov [choose],5
	  jmp endl
case6:
      mov [seletedWordLen],11
	  mov [choose],6
	  jmp endl
case7:
      mov [seletedWordLen],9
	  mov [choose],7
	  jmp endl
case8:
      mov [seletedWordLen],13
	  mov [choose],8
	  jmp endl
case9:
      mov [seletedWordLen],14
	  mov [choose],9
	  jmp endl
case10: 
	  mov [seletedWordLen],9
	  mov [choose],10
	  jmp endl
elsee:
	cmp bl,10
	je case11
	cmp bl,11
	je case12
	cmp bl,12
	je case13
	cmp bl,13
	je case14
	cmp bl,14
	je case15
	cmp bl,15
	je case16
case11:
      mov [seletedWordLen],9
	  mov [choose],11
	  jmp endl
case12:
      mov [seletedWordLen],8
	  mov [choose],12
	  jmp endl
case13:
      mov [seletedWordLen],8
	  mov [choose],13
	  jmp endl
case14:
      mov [seletedWordLen],8
	  mov [choose],14
	  jmp endl
case15:
      mov [seletedWordLen],8
	  mov [choose],15
	  jmp endl
case16:
      mov [seletedWordLen],8
	  mov [choose],16
	  jmp endl
case17:
      mov [seletedWordLen],8
	  mov [choose],17
	  jmp endl
endl:
      ret
endp get_length	

proc print_word 
    cmp bl,0
	je caseee1
	cmp bl,1
	je caseee2
	cmp bl,2
	je caseee3
	cmp bl,3
	je caseee4
	cmp bl,4
	je caseee5
	cmp bl,5
	je caseee6
	cmp bl,6
	je caseee7
	cmp bl,7
	je caseee8
	cmp bl,8
	je caseee9
	cmp bl,9
	je caseee10
	jmp elseeee
caseee1:
     mov dx,offset word1
	 jmp endh
caseee2:
      mov dx,offset word2
	  jmp endh
caseee3:
      mov dx,offset word3
	  jmp endh
caseee4:
      mov dx,offset word4
	  jmp endh
caseee5:
      mov dx,offset word5
	  jmp endh
caseee6:
      mov dx,offset word6
	  jmp endh
caseee7:
      mov dx,offset word7
	  jmp endh
caseee8:
      mov dx,offset word8
	  jmp endh
caseee9:
      mov dx,offset word9
	  jmp endh
caseee10: 
	  mov dx,offset word10
	  jmp endh
elseeee:
	cmp bl,10
	je caseee11
	cmp bl,11
	je caseee12
	cmp bl,12
	je caseee13
	cmp bl,13
	je caseee14
	cmp bl,14
	je caseee15
	cmp bl,15
	je caseee16
caseee11:
      mov dx,offset word11
	  jmp endh
caseee12:
      mov dx,offset word12
	  jmp endh
caseee13:
      mov dx,offset word13
	  jmp endh
caseee14:
      mov dx,offset word14
	  jmp endh
caseee15:
      mov dx,offset word15
	  jmp endh
caseee16:
      mov dx,offset word16
	  jmp endh
endh:
     ret
endp print_Word
;enter- none
;exit-  get input from the user or give 0
proc get_input
	dopush ax,es,dx,bx
    mov ax,ds
	mov es,ax
	mov bx, offset String
	add bl,[countSt]
   
typee:
    mov ah,01h
	int 16h
	jz done;checks the word until the user has'nt put anything
	
    mov ah,00h
	int 16h
	
	; exit if ESC pressed
	cmp	ah, 1h	
	je escp
	
	cmp al,0dh ;check if he has put enter key
	je enterp
	
	mov [bx], al
	inc [countSt]
	
	mov dl,al
	call print_char;call to print_char
	jmp done
escp:
	mov [pressEnter], 2
	jmp done
enterp:
	mov [pressEnter], 1
done:
    dopop bx, dx,es,ax
    ret
endp get_input
;enter- char in dl
;exit- output the char
proc print_char
	mov ah,2h
	int 21h;output the char
	ret
endp print_char
;enter- input String from the user
;exit- 1 if he failed 0 if he gussed
proc check_word
	doPush ax, es,si,di,cx
	mov [correct], 0
	mov al, [countSt]
	cmp al, [seletedWordLen]
	jne lostt;if the length are not the same
	
	mov ax, ds
	mov es, ax
	call get_selected_word
	mov di, offset String
	xor ch,ch
	;mov cl,[countSt]
	mov cx,5
	repe cmpsb
    je retCheck_word	
	cmp cx,0
	je retCheck_word

lostt:
    mov [correct],1
retCheck_word:
    mov [countSt],0
	doPop cx,di,si,es,ax
	ret
endp check_word

proc get_selected_word
    cmp bl,1
	je casee1
	cmp bl,2
	je casee2
	cmp bl,3
	je casee3
	cmp bl,4
	je casee4
	cmp bl,5
	je casee5
	cmp bl,6
	je casee6
	cmp bl,7
	je casee7
	cmp bl,8
	je casee8
	cmp bl,9
	je casee9
	cmp bl,10
	je casee10
	jmp elseee
casee1:
     mov si,offset word1
	 jmp endo
casee2:
      mov di,offset word2
	  jmp endo
casee3:
      mov si,offset word3
	  jmp endo
casee4:
      mov si,offset word4
	  jmp endo
casee5:
      mov si,offset word5
	  jmp endo
casee6:
      mov si,offset word6
	  jmp endo
casee7:
      mov si,offset word7
	  jmp endo
casee8:
      mov si,offset word8
	  jmp endo
casee9:
      mov si,offset word9 
	  jmp endo
	
elseee:
    cmp bl,11
	je casee11
	cmp bl,12
	je casee12
	cmp bl,13
	je casee13
	cmp bl,14
	je casee14
	cmp bl,15
	je casee15
	cmp bl,16
	je casee16
casee10: 
	  mov si,offset word10
	  jmp endo
casee11:
      mov si,offset word11
	  jmp endo
casee12:
      mov si,offset word12
	  jmp endo
casee13:
      mov si,offset word13
	  jmp endo
casee14:
      mov si,offset word14
	  jmp endo
casee15:
      mov si,offset word15
	  jmp endo
casee16:
      mov si,offset word16
	  jmp endo
endo:
      ret
endp get_selected_word