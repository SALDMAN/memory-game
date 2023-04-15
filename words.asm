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
	and bl, 00011111b 		; leave result between 0-31
	
    shl bx,1
	xor bh, bh
	
	cmp bx,31
	ja again;if the random number is above 31
	
	call get_length;to get the length of the random word 	
	call print_Word;to print the random word
	mov ah,9h
	int 21h	;output the word
	jmp endr
again:
    ;when the random num is above 15
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
	jmp elsee
case1:
     mov [seletedWordLen],11
	 mov [choose],1
	 mov [was],1
	 jmp endl
case2:
      mov [seletedWordLen],19
	  mov [choose],2
	  mov [was],2
	  jmp endl
case3:
      mov [seletedWordLen],16
	  mov [choose],3
	  mov [was],3
	  jmp endl
case4:
      mov [seletedWordLen],11
	 mov [was],4
	  mov [choose],4
	  jmp endl
case5:
      mov [seletedWordLen],14
	  mov [was],5
	  mov [choose],5
	  jmp endl
case6:
      mov [seletedWordLen],15
	  mov [was],6
	  mov [choose],6
	  jmp endl
case7:
      mov [seletedWordLen],11
	  mov [was],7
	  mov [choose],7
	  jmp endl
case8:
      mov [seletedWordLen],16
	  mov [was],8
	  mov [choose],8
	  jmp endl
case9:
      mov [seletedWordLen],11
	  mov [was],9
	  mov [choose],9
	  jmp endl
case10: 
	  mov [seletedWordLen],9
	  mov [was],10
	  mov [choose],10
	  jmp endl
elsee:
    cmp bl,6
	je case7
	cmp bl,7
	je case8
	cmp bl,8
	je case9
	cmp bl,9
	je case10
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
	jmp iff
case11:
      mov [seletedWordLen],12
	  mov[was],11
	  mov [choose],11
	  jmp endl
case12:
      mov [seletedWordLen],9
	  mov [was],12
	  mov [choose],12
	  jmp endl
case13:
      mov [seletedWordLen],8
	  mov [was],13
	  mov [choose],13
	  jmp endl
elseiff:
     cmp bl,13
	je case14
	cmp bl,14
	je case15
	cmp bl,15
	je case16
	jmp iff
case14:
      mov [seletedWordLen],8
	  mov [was],14
	  mov [choose],14
	  jmp endl
case15:
      mov [seletedWordLen],10
	  mov [was],15
	  mov [choose],15
	  jmp endl
case16:
      mov [seletedWordLen],9
	  mov [was],16
	  mov [choose],16
	  jmp endl
iff:
    cmp bl,16
	je case17
	cmp bl,17
	je case18
	cmp bl,18
	je case19
	cmp bl,19
	je case20
	cmp bl,20
	je case21
	cmp bl,21
	je case22
	cmp bl,22
	je case23
	jmp last_words
case17:
     mov [seletedWordLen],10
	 mov [choose],17
	 mov [was],17
	 jmp endl
case18:
      mov [seletedWordLen],9
	  mov [choose],18
	  mov [was],18
	  jmp endl
case19:
      mov [seletedWordLen],12
	  mov [choose],19
	  mov [was],19
	  jmp endl
case20:
      mov [seletedWordLen],9
	 mov [was],20
	  mov [choose],20
	  jmp endl
case21:
      mov [seletedWordLen],10
	  mov [was],21
	  mov [choose],21
	  jmp endl
case22:
      mov [seletedWordLen],11
	  mov [was],22
	  mov [choose],22
	  jmp endl
case23:
      mov [seletedWordLen],11
	  mov [was],23
	  mov [choose],23
	  jmp endl
last_words:
	cmp bl,23
	je case24
	cmp bl,24
	je case25
	cmp bl,25
	je case26
    cmp bl,26
	je case27
	cmp bl,27
	je case28
	cmp bl,28
	je case29
	cmp bl,29
	je case30
	jmp last
case24:
      mov [seletedWordLen],9
	  mov [was],24
	  mov [choose],24
	  jmp endl
case25:
      mov [seletedWordLen],11
	  mov [was],25
	  mov [choose],25
	  jmp endl
case26: 
	  mov [seletedWordLen],12
	  mov [was],26
	  mov [choose],26
case27:
      mov [seletedWordLen],13
	  mov [was],27
	  mov [choose],27
	  jmp endl
case28:
      mov [seletedWordLen],11
	  mov [was],28
	  mov [choose],28
	  jmp endl
case29:
      mov [seletedWordLen],11
	  mov [was],29
	  mov [choose],29
	  jmp endl
case30:
      mov [seletedWordLen],15
	  mov [was],30
	  mov [choose],30
	  jmp endl
last:
	cmp bl,30
    je case31
	cmp bl,31
	je case32
case31:
      mov [seletedWordLen],13
	  mov [was],31
	  mov [choose],31
	  jmp endl
case32: 
	  mov [seletedWordLen],10
	  mov [was],32
	  mov [choose],32
	  jmp endl
endl:
      ret
endp get_length	
;enter - a random num
;exit - print the word
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
	jmp ifff
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
ifff:
    cmp bl,16
	je caseee17
	cmp bl,17
	je caseee18
	cmp bl,18
	je caseee19
	cmp bl,19
	je caseee20
	cmp bl,20
	je caseee21
	cmp bl,21
	je caseee22
	cmp bl,22
	je caseee23
	cmp bl,23
	je caseee24
	jmp elseifff
caseee17:
      mov dx,offset word17
	  jmp endh
caseee18:
      mov dx,offset word18
	  jmp endh
caseee19:
      mov dx,offset word19
	  jmp endh
caseee20:
      mov dx,offset word20
	  jmp endh
caseee21:
      mov dx,offset word21
	  jmp endh
caseee22:
      mov dx,offset word22
	  jmp endh
caseee23:
     mov dx,offset word23
	 jmp endh
caseee24:
     mov dx,offset word24
	 jmp endh
elseifff:
     cmp bl,24
	 je caseee25
	 cmp bl,25
	 je caseee26
	 cmp bl,26
	 je caseee27
	 cmp bl,27
	 je caseee28
	 cmp bl,28
	 je caseee29
	 cmp bl,29
	 je caseee30
	 cmp bl,30
	 je caseee31
	 cmp bl,31
	 je caseee32
caseee25:
      mov dx,offset word25
	  jmp endh
caseee26:
      mov dx,offset word26
	  jmp endh
caseee27:
      mov dx,offset word27
	  jmp endh
caseee28:
      mov dx,offset word28
	  jmp endh
caseee29:
      mov dx,offset word29
	  jmp endh
caseee30:
     mov dx,offset word30
	 jmp endh
caseee31:
     mov dx,offset word31
caseee32:
     mov dx,offset word32
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
	cmp [wrong],1
	je clean_screen
first:
	mov bx, offset String
	add bl,[countSt]
	jmp typee
clean_screen:
    MoveGrafic
	mov dx,offset tell
	mov ah,9h
	int 21h
	jmp first
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
	;check if the length are not the same
	mov al, [countSt]
	cmp al, [seletedWordLen]
	jne lostt
	
	mov ax, ds
	mov es, ax
	call get_selected_word
	mov di, offset String
	xor ch,ch
	mov cl,[countSt]
	;check the input word that in di with the word that in si 
	repe cmpsb
    je retCheck_word
lostt:
    mov [correct],1
retCheck_word:
    mov [countSt],0
	doPop cx,di,si,es,ax
	ret
endp check_word
;enter - inside choose which num has random
;exit - inside si the offset of the word 
proc get_selected_word
;cmp with every num between 1-32 which word is it and put it inside si
    cmp [choose],1
	je casee1
	cmp [choose] ,2
	je casee2
	cmp [choose],3
	je casee3
	cmp [choose],4
	je casee4
	cmp [choose],5
	je casee5
	cmp [choose],6
	je casee6
	cmp [choose],7
	je casee7
	cmp [choose],8
	je casee8
	cmp [choose],9
	je casee9
	cmp [choose],10
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
    cmp [choose],11
	je casee11
	cmp [choose],12
	je casee12
	cmp [choose],13
	je casee13
	cmp [choose],14
	je casee14
	cmp [choose],15
	je casee15
	cmp [choose],16
	je casee16
	jmp iffff
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
iffff:
    cmp [choose],17
	je casee17
	cmp [choose],18
	je casee18
	cmp [choose],19
	je casee19
	cmp [choose],21
	je casee21
	cmp [choose],22
	je casee22
	cmp [choose],23
	je casee23
	cmp [choose],24
	je casee24
	cmp [choose],25
	je casee25
	cmp [choose],26
	je casee26
	cmp [choose],27
	je casee27
	jmp else_ifff
casee17:
     mov si,offset word17
	 jmp endo
casee18:
      mov di,offset word18
	  jmp endo
casee19:
      mov si,offset word19
	  jmp endo
casee20:
      mov si,offset word20
	  jmp endo
casee21:
      mov si,offset word21
	  jmp endo
casee22:
      mov si,offset word22
	  jmp endo
casee23:
      mov si,offset word23
	  jmp endo
casee24:
      mov si,offset word24
	  jmp endo
casee25:
      mov si,offset word25
	  jmp endo
casee26:
      mov si,offset word26 
	  jmp endo
casee27:
     mov si,offset word27
	 jmp endo
	 
else_ifff:
     cmp [choose],28
	je casee28
	cmp [choose],29
	je casee29
	cmp [choose],30
	je casee30
	cmp [choose],31
	je casee31
	cmp [choose],32
	je casee32
casee28:
      mov si,offset word28
	  jmp endo
casee29:
      mov si,offset word29
	  jmp endo
casee30:
      mov si,offset word30
	  jmp endo
casee31:
      mov si,offset word31
	  jmp endo
casee32:
      mov si,offset word32
	  jmp endo
endo:
      ret
endp get_selected_word