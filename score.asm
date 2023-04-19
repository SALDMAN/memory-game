


; Input – filehandle, Header
; Output - read BMP file header, 54 bytes
proc readTable
    dopush ax,bx,cx,dx
	mov ah, 3fh
	mov bx, [filehandle]
	mov cx,8; Read 4 bytes
	mov dx, offset buffer
	int 21h
	dopop dx,cx,bx,ax
ret
endp readTable

	
; enter – bestScore 
; exit - sort the places from small to large in score table in bestScore array
proc sortScoreTable
    dopush ax,bx
	; Initialize
	mov al, [bestScore]
	mov ah, [bestScore + 1]
	mov bh, [bestScore + 2]
	
	; If the first number is bigger than the second number replace them, else dont replace
	cmp al, ah
	ja replace0With1
	jmp dontReplace0With1
	
replace0With1:
	; Swap 0 with 1
	mov bl, al
	mov al, ah
	mov ah, bl
	
; After the first number and the second number are arranged from smallest to largest
dontReplace0With1:
	; If the second number is greater than the third number replace them, else the array is sorted
	cmp ah, bh
	ja replace1With2
	jmp returnSortScoreTable

replace1With2:
	; Swap 1 with 2
	mov bl, ah
	mov ah, bh
	mov bh, bl
	
	; If there was an exchange between the second and third number
	; it is necessary again regarding the exchange between the first number and the second
	; If the first number is less than or equal to the second number the array is ordered else replace the first number with the second
	cmp al, ah
	jbe returnSortScoreTable
	
	; Swap 0 with 1
	mov bl, al
	mov al, ah
	mov ah, bl

returnSortScoreTable:
	mov [bestScore],al			; Third place
	mov [bestScore + 1],ah		; Second place
	mov [bestScore + 2],bh		; First place
	
	; Updates the places according to the array
	mov [firstPlace], bh
	mov [secondPlace], ah
	mov [thirdPlace], al
	dopop bx,ax
    ret
endp sortScoreTable

;proc print_table
; ; display read data
;    mov ah,9h
;    mov dx ,offset buffer
;    int 21h
;    ret
;endp print_table
;
;;enter - var for data
;; exit - put the data in file
;proc write_to_table
;    doPush ax,bx,cx,dx
;       ; write to file
;    mov ah, 40h
;    mov bx, [fileHandle]
;    mov dx, offset 	Message  ; address of data to write
;    mov cx, 4 ; number of bytes to write
;    int 21h
;    jc ERRORR ; jump to error handler if write failed
;    ; close file
;    mov ah, 3eh
;    mov bx,[ fileHandle]
;    int 21h
;    jmp return
;ERRORR:
;    mov ah,9h
;	mov dx,offset errormsg
;	jmp return
;return:
;    doPop dx,cx,bx,ax
;    ret
;endp write_to_table


; enter - gamePoints
; exit - checks if the record should enter the table and inserts it if necessary
proc checkIfShouldEnterScoreTable
	; Initialize
	mov bx, [points]
	xor ah, ah
	mov al, [bestScore] 	; Third place
	; If the record is not greater than the third place in the table, do nothing
	; else put it in the table instead of the third place and rearrange the array
	cmp bx, ax
	jbe returnAfterCheckGamePoints
	mov [bestScore], bl
	call sortScoreTable
	
returnAfterCheckGamePoints:
	
ret
endp checkIfShouldEnterScoreTable


; Input - firstPlace
; Output - print the first place in the score table in score table screen
proc printFirstPlace
	; Position of the points
	mov [x], 20
	mov [y], 7
	; Points to print
	xor ah, ah
	mov al, [firstPlace]
	mov [currentPoints], ax
	; White color
	mov [currentPointsColor], 7
	call printPoints
ret
endp printFirstPlace
	
;----------------------------------------------------------------------------------------------------
	
; Input - secondPlace
; Output - print the second place in the score table in score table screen
proc printSecondPlace
	; Position of the points
	mov [x], 20
	mov [y], 9
	; Points to print
	xor ah, ah
	mov al, [secondPlace]
	mov [currentPoints], ax
	; White color
	mov [currentPointsColor], 7
	call printPoints
ret
endp printSecondPlace
	
;----------------------------------------------------------------------------------------------------
	
; Input - thirdPlace
; Output - print the third place in the score table in score table screen
proc printThirdPlace
	; Position of the points
	mov [x], 20
	mov [y], 11
	; Points to print
	xor ah, ah
	mov al, [thirdPlace]
	mov [currentPoints], ax
	; White color
	mov [currentPointsColor], 7
	call printPoints
ret
endp printThirdPlace

proc printPoints
	doPush ax,bx,cx,dx

	mov ah, 2h
	; Screen number
	mov bh, 0
	; Number column
	mov dl, [x]
	; Number line
	mov dh, [y]
	int 10h
	mov ax, [currentPoints]
	; Number = ax;
	mov [tempPoints], ax
	mov [digitsCount], 0

; Get digits one by one (save any digit on stack)
getDigits:
	; Number/10: ax = number/10, dx: number % 10
	mov ax, [tempPoints]
	; The division remainder
	xor dx, dx				
	mov bx, 10
	div bx
	; Push number%10
	push dx
	; Number = number/10;
	mov [tempPoints], ax
	inc [digitsCount]
	; If number = 0 go to getDigitsEnd
	cmp [tempPoints], 0
	jne getDigits     		

; Print digits one by one (digits on stack)
printDigits:
	; If digitsCount = 0 go to printDigitsEnd
	cmp [digitsCount], 0
	je returnAfterPrintDigits
	; Pop digit into al
	pop ax
	; Usig ascii table to convert int to char
	add al, 30h
	; Wanna print digit
	mov ah, 0eh
	; Color
	mov bl, [currentPointsColor]
	int 10h
	dec [digitsCount]
	jmp printDigits

returnAfterPrintDigits:
	
	doPop dx,cx,bx,ax
ret
endp printPoints
	proc writeTable
	mov ah, 40h
	mov bx, [filehandle]
	mov cx, 3		; Write 3 bytes
	mov dx, offset bestScore
	int 21h
ret
endp writeTable
proc sorts
    mov dx,offset scoreTable					
    call openFile
	call readTable
	call closeFile
	call sortScoreTable
	call checkIfShouldEnterScoreTable
	call openFile
	;call writeTable
	call closeFile
	ret
endp sorts

proc call_for_print
    call printFirstPlace
	call printSecondPlace
	call printThirdPlace
	ret
endp call_for_print


