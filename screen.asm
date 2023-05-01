proc OpenFile
	;enter- filehandle(word), offset ErrorMsg(byte)
	;exit - open file and if didnג€™t succeed print errormsg  and exit
	; NOTE: dx=offset of name of file. is set before the call to this proc
	mov ah,3Dh
	mov al,2					;reading and writing
	int 21h
	jc openError
	mov [filehandle],ax
	ret
openError:
	;if not succeed open- print error and exit
	mov dx,offset ErrorMsg		
	mov ah,9h
	int 21h
	;print which kind of error
	mov dl,al					;move the error code to dl to print it
	add dl,'0'					;turn the error code to a number
	mov ah,2					;print
	int 21h
	jmp exit
	ret
endp OpenFile
;==================================================
;==================================================
proc ReadFile
	;enter- Buffer(size byte) , filehandle(size word)
	;exit - read the file's data(move the file's data to the buffer) [the file is the table of records] 
	mov ah,3Fh
	mov bx,[filehandle]			;bx=file's handle
	mov cx,48*3					;cx= amount of bytes to read [48*3 because: 3 lines. in 1 line: 20 of name + 20 of space between name and score + 5 bytes of score + 1of $ + 2 of go down a line and to its start (13,10)]
	mov dx,offset Buffer		;dx= offset of array that file will be copied into= buffer
	int 21h
	ret
endp ReadFile
;==================================================
proc CloseFile
	;enter- filehandle(size word)
	;exit - Close file
	mov ah,3Eh
	mov bx,[filehandle]
	int 21h
	ret
endp CloseFile

proc BMP
	;enter- calls openfile, errorCode(byte), filehandle(word), Header,Palette,ScrLine (byte), height,wid,left,top(size word), calls closefile
	;exit - print BMP file
	; open file:
	call OpenFile
	
ReadHeader:
	; Read BMP file header, 54 bytes
    mov ah,3fh
    mov bx,[filehandle]
    mov cx,54
    mov dx,offset Header
    int 21h
	
ReadPalette:
	; Read BMP file color palette, 256 colors * 4 bytes (400h)
    mov ah,3fh
    mov cx,400h 
    mov dx,offset Palette
    int 21h 
	
CopyPal:
	; Copy the colors palette to the video memory registers 
	; The number of the first color should be sent to port 3C8h
	; The palette is sent to port 3C9h
	mov si,offset Palette 
	mov cx,256 
	mov dx,3C8h
	mov al,0 
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h
	inc dx 
PalLoop:
	;Note: Colors in a BMP file are saved as BGR values rather than RGB.
	mov al,[si+2] 			; Get red value.
	shr al,2 				; Max. is 255, but video palette maximal value is 63. Therefore dividing by 4.
	out dx,al				; Send it.
	mov al,[si+1] 			; Get green value.
	shr al,2
	out dx,al 				; Send it.
	mov al,[si] 			; Get blue value.
	shr al,2
	out dx,al 				; Send it.
	add si,4		 		; Point to next color.
	; (There is a null chr. after every color.)
	loop PalLoop
	
CopyBitmap:
	; BMP graphics are saved upside-down.
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax, 0A000h
	mov es, ax
	mov cx,[picHigh]			;height of picture (until 200)
PrintBMPLoop:
	push cx
	; di = cx*320, point to the correct screen line
	mov di,cx 
	shl cx,6 
	shl di,8 
	add di,cx
	
	add di,[left]			;add from left side
	add di,[top]			;add from top side
	; Read one line
	mov ah,3fh
	mov cx,[picWidth]			;width of picture (until 320)
	mov dx,offset ScrLine
	int 21h 
	; Copy one line into video memory
	cld 					; Clear direction flag, for movsb
	mov cx,[picWidth]
	mov si,offset ScrLine
	rep movsb 				; Copy line to the screen
	pop cx
	loop PrintBMPLoop
	
	call closefile
	Ret
endp BMP

proc mainscreen
	;enter- background(byte),calls BMP
	;exit - print the sky
	mov dx,offset open
	mov [picHigh],200
	mov [picWidth],320
	mov [left],0
	mov [top],0
	call BMP
	ret
endp mainscreen

proc instractionscreen
	;enter- unic(byte),calls BMP
	;exit - print the unicorn
	mov dx,offset instraction	
	mov [picHigh],200
	mov [picWidth],320
	mov ax,[newPos]
	mov [oldPos],ax
	mov [left],ax
	call BMP
	ret
endp instractionscreen

proc losescreen
	;enter- background(byte),calls BMP
	;exit - print the sky
	push dx
	mov dx,offset lose
	mov [picHigh],200
	mov [picWidth],320
	mov [left],0
	mov [top],0
	call BMP
	pop dx
	ret
endp losescreen

proc extra_screen
	;enter- extra pic
	;exit - print the pic
	push dx
	mov dx,offset bonus
	mov [picHigh],200
	mov [picWidth],320
	mov ax,[newPos]
	mov [oldPos],ax
	mov [left],ax
	call BMP
	pop dx
	ret
endp extra_screen