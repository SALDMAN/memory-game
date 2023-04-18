;====================================================================================================
;											BMP procs
;====================================================================================================

; Input – file name in filename variable
; Output - open file, put handle in filehandle
proc openFile
	mov ah, 3Dh
	mov al, 2 	  ; Read-Write open mode
	mov dx, [currentFile]
	int 21h
	jc openError
	mov [filehandle], ax
ret
openError:
	mov dx, offset ErrorMsg
	mov ah, 9h
	int 21h
	mov ax, 4c00h ; exit the program
	int 21h
endp openFile

;----------------------------------------------------------------------------------------------------

; Input – filehandle, Header
; Output - read BMP file header, 54 bytes
proc readHeader
	mov ah, 3fh
	mov bx, [filehandle]
	mov cx, 54
	mov dx,offset Header
	int 21h 
ret
endp readHeader

;----------------------------------------------------------------------------------------------------

; Input - filehandle, Header
; Output - read BMP file color palette, 256 colors * 4 bytes (400h)
proc readPalette
	mov ah, 3fh
	mov bx, [filehandle]
	mov cx, 400h
	mov dx, offset Palette
	int 21h
ret
endp readPalette

;----------------------------------------------------------------------------------------------------

; Input - BMP color palette
; Output - copy the colors palette to the video memory registers and get RGB colors and not BGR colors
proc copyPalette
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
	mov si, offset Palette 
	mov cx, 256 
	mov dx, 3C8h
	mov al, 0 
	; Copy starting color to port 3C8h
	out dx,al
	; Copy palette itself to port 3C9h
	inc dx 
PalLoop:
; Note: Colors in a BMP file are saved as BGR values rather than RGB.
	mov al, [si+2] 	; Get red value.
	shr al, 2 		; Max. is 255, but video palette maximal
 ; value is 63. Therefore dividing by 4.
	out dx, al		 ; Send it.
	mov al, [si+1] 	; Get green value.
	shr al, 2
	out dx, al 		; Send it.
	mov al, [si] 	; Get blue value.
	shr al, 2
	out dx, al 		; Send it.
	add si, 4		 ; Point to next color.
 ; (There is a null chr. after every color.)
	loop PalLoop
ret
endp copyPalette

;----------------------------------------------------------------------------------------------------

; Input - filehandle
; Output - Read the graphic line by line (200 lines in VGA format) displaying the lines from bottom to top
proc copyBitmap
	; Read the graphic line by line (200 lines in VGA format),
	; displaying the lines from bottom to top.
	mov ax, 0A000h
	mov es, ax
	mov cx,[picHigh]
	PrintBMPLoop:
	push cx
	; di = cx*320, point to the correct screen line
	mov di, cx 
	shl cx, 6 
	shl di, 8 
	add di, cx
	
	add di,[leftGap]
	add di,[topGap]
	
	; Read one line
	mov ah, 3fh
	mov cx,[picWidth]
	mov dx, offset ScrLine
	int 21h 
	; Copy one line into video memory
	cld 		; Clear direction flag, for movsb
	mov cx, 320
	mov si, offset ScrLine
	rep movsb 	; Copy line to the screen
	pop cx
	loop PrintBMPLoop
ret
endp copyBitmap

;----------------------------------------------------------------------------------------------------

; Input - filehandle
; Output - close the file
proc closeFile
	mov ah, 3Eh
	mov bx, [filehandle]
	int 21h
ret
endp closeFile

;----------------------------------------------------------------------------------------------------

; Input - no parameters
; Output - print the pic
proc printPic
	call openFile
	call readHeader
	call readPalette
	call copyPalette
	call copyBitmap
	call closeFile
ret
endp printPic

;====================================================================================================
;											Character procs
;====================================================================================================

; Input - newPosition, qb_height, qb_width, currentScreenKeep
; Output - take square height X square width bytes from screen into currentScreenKeep variable
proc takeSquare
	doPush es, ax, si, di, cx
	
	mov ax, 0A000h
	mov es, ax
	mov di, [newPosition]
	mov si, [currentScreenKeep]
	mov cx, [qb_height]
takeLine:
	push cx
	mov cx, [qb_width]
takeColumn:
	mov al, [es:di]
	mov [si], al
	inc si
	inc di
	loop takeColumn
	add di, 320
	sub di, [qb_width]
	pop cx
	loop takeLine
	
	doPop cx, di, si, ax, es
ret
endp takeSquare

;----------------------------------------------------------------------------------------------------

; Input - oldPosition, qb_height, qb_width, currentScreenKeep
; Output - return square height X square width bytes from currentScreenKeep into screen
proc returnSquare
	doPush es, ax, si, di, cx
	
	mov ax,0A000h
	mov es,ax
	mov di,[oldPosition]
	mov si, [currentScreenKeep]
	mov cx, [qb_height]
retLine:
	push cx
	mov cx, [qb_width]
retColumn:
	mov al,[si]
	mov [es:di],al
	inc si
	inc di
	loop retColumn
	add di, 320
	sub di, [qb_width]
	pop cx
	loop retLine

	doPop cx, di, si, ax, es
ret
endp returnSquare

;----------------------------------------------------------------------------------------------------

; Input - newPosition, charOff – offset of character
; Output - anding between character and screen, creates a "black hole" on the screen to plant the character
proc anding
	doPush ax, es, di, si, cx
	
	mov ax, 0A000h
	mov es, ax
	mov di, [newPosition]
	mov si, offset ballMask
	mov cx, [qb_height]
andLine:
	push cx
	mov cx,[qb_width]
andColumn:
	lodsb
	and [es:di], al
	inc di
	loop andColumn
	add di,320
	sub di, [qb_width]
	pop cx
	loop andLine	
	
	doPop cx, si, di, es, ax
ret
endp anding

;----------------------------------------------------------------------------------------------------

; Input - newPosition, charOff – offset of character
; Output - oring between character and screen, operation or to get the character without the frame
proc oring
	doPush ax, es, di, si, cx

	mov ax, 0A000h
	mov es, ax
	mov di, [newPosition]
	mov si, [currentBall]
	mov cx, [qb_height]
orLine:
	push cx
	mov cx, [qb_width]
orColumn:
	lodsb
	or [es:di], al
	inc di
	loop orColumn
	add di, 320
	sub di, [qb_width]
	pop cx
	loop orLine	
	
	doPop cx, si, di, es, ax
ret
endp oring

;----------------------------------------------------------------------------------------------------

; Input - no parameters
; Output - print the ball in the current position, size and color
proc printBall
	call takeSquare
	call anding
	call oring
ret
endp printBall
	
;----------------------------------------------------------------------------------------------------
	
; Input - no parameters
; Output - print the main ball in mid road in random color
proc printMainBall
	doPush ax

	; Startin position of the main ball (mid road)
	mov [oldPositionMainBall], 160*320+152
	mov [newPositionMainBall], 160*320+152
	
	; Position
	mov ax, [oldPositionMainBall]
	mov [oldPosition], ax
	mov ax, [newPositionMainBall]
	mov [newPosition], ax
	
	; The size of the square
	mov [qb_width], 30
	mov [qb_height], 30
	
	mov [currentScreenKeep], offset mainBallScreenKeep
	
	; Get random color to the first ball
	; Get random number from 1 - 3 into al
	call getRandomNumberFromOneToTrhee

	cmp al, 1
	je redMainBall
	cmp al, 2
	je greenMainBall
	; Not red or green so it must be blue
	jmp blueMainBall
	
redMainBall:
	; Change the color of the ball to red
	mov [mainBallColor], offset redBall
	mov ax, [mainBallColor]
	jmp printMainBallInRandomColor
	
greenMainBall:
	; Change the color of the ball to green
	mov [mainBallColor], offset greenBall
	mov ax, [mainBallColor]
	jmp printMainBallInRandomColor
	
blueMainBall:
	; Change the color of the ball to blue
	mov [mainBallColor], offset blueBall
	mov ax, [mainBallColor]
	
printMainBallInRandomColor:
	mov [currentBall], ax
	
	; Print the ball in the random color
	call printBall
	
	doPop ax
ret
endp printMainBall
	
;----------------------------------------------------------------------------------------------------
	
; Input - no parameters
; Output - move the character left or right
proc moveCharacter
	; Position
	mov ax, [newPositionMainBall]
	mov [newPosition], ax
	mov ax, [oldPositionMainBall]
	mov [oldPosition], ax
	
	; The size of the square
	mov [qb_width], 30
	mov [qb_height], 30
	
	mov [currentScreenKeep], offset mainBallScreenKeep
	
	; The color of the ball
	mov ax, [mainBallColor]
	mov [currentBall], ax

	call returnSquare
	call anding
	call oring
	
	; Updates the current position of the main ball
	mov ax, [newPositionMainBall]
	mov [oldPositionMainBall], ax
ret
endp moveCharacter

;====================================================================================================
;											Random Color procs
;====================================================================================================

; Input - no parameters
; Output - return random number between 1 - 3 in al
proc getRandomNumberFromOneToTrhee

	; Initialize
	mov ax, 40h
	mov es, ax
	mov bx, 0
	
newColor:
	; Generate random number
	; Read timer counter
	mov ax, [Clock]
	; Read one byte from memory
	mov ah, [byte cs:bx]
	; Xor memory and counter
	xor al, ah
	; Leave result between 0 - 3
	and al, 00000011b
	inc bx
	; If the number is 0 go back and get another number
	cmp al, 0
	je newColor
	
ret
endp getRandomNumberFromOneToTrhee

;----------------------------------------------------------------------------------------------------

; Input - no parameters
; Output - return array (randomBallsColorArray) with 3 numbers in random newPositions between 1 - 3
proc getArrayOfTrheeRandomNumbers
	
	; Get random number between 1 - 3 in al
	call getRandomNumberFromOneToTrhee
	
	mov [randomBallsColorArray], al
	
	; Get random number between 1 - 3 in al
	call getRandomNumberFromOneToTrhee
	
; Find second number are not equals to the fisrt number
secondNumber:
	; If the second number is equal to the first number you will get another number else you will add to the array
	cmp al, [randomBallsColorArray]
	je secondEqualFirst
	
	mov [randomBallsColorArray + 1], al
	
	; Get random number between 1 - 3 in al
	call getRandomNumberFromOneToTrhee
	
; Find third number are not equals to the fisrt number and to the second number
thirdNumber:
	; If the second number is equal to the first or the second number you will get another number else you will add to the array
	cmp al, [randomBallsColorArray]
	je thirdEqualFirstOrSecond
	cmp al, [randomBallsColorArray + 1]
	je thirdEqualFirstOrSecond
	
	mov [randomBallsColorArray + 2], al
	
	jmp returnAfterGetRandomArray
	
; Get another number for third number = fisrt number / = second number
thirdEqualFirstOrSecond:
	; Get random number between 1 - 3 in al
	call getRandomNumberFromOneToTrhee
	jmp thirdNumber
	
; Get another number for second number = fisrt number
secondEqualFirst:
	; Get random number between 1 - 3 in al
	call getRandomNumberFromOneToTrhee
	jmp secondNumber
	
returnAfterGetRandomArray:

ret
endp getArrayOfTrheeRandomNumbers

;====================================================================================================
;											Screens proc
;====================================================================================================

; Input - no parameters
; Output - go between screens and return 1 if start the game else return 0
proc screens
	
	; If the main ball not touched the same color of the second ball print the end game screen
	cmp [isSameColor], 1
	je printEndGameScreen
	
printStartScreen:
	; Print the start screen
	mov [currentFile], offset startScreen
	call printPic
	
	; Play move between screens sound
	mov ax, 7239 	; Mi
	call playSound
	
waitForData:
	; Get input
	mov ah, 7h
	int 21h
	cmp al, 1bh		; Escape pressed for exit the game
	je cleanup
	cmp al, 20h		; Space pressed for start the game
	je printStartGameScreen
	cmp al, 69h		; i pressed for instructions screen
	je printInstructionsScreen
	cmp al, 49h		; I pressed for instructions screen
	je printInstructionsScreen
	
	jmp waitForData
	
printStartGameScreen:
	; Play start game sound
	mov cx, 3
startGameSoundLoop:
	mov ax, 6087 	; Sol
	call playSound
	call delayProc
	loop startGameSoundLoop
	
	; Print the game screen
	mov [currentFile], offset gameScreen
	call printPic
	
	; Takes the first line of the track of the game
	call takeFirstLine
	
	; Reset the points every time you start the game
	mov [gamePoints], 0
	; Print the number 0 for the points
	call printInGamePoints
	; Reset the variables
	mov [startGame], 1
	mov [isSameColor], 0
	mov [currentRoadNumber], 2
	
	; Print the main ball
	call printMainBall
	
	jmp return
	
printInstructionsScreen:
	; Play move between screens sound
	mov ax, 7239 	; Mi
	call playSound
	
	; Print the instructions screen
	mov [currentFile], offset instructionsScreen
	call printPic
	
waitForDataGoBackToStrat:
	; Get input
	mov ah, 7h
	int 21h
	cmp al, 1bh		; Escape pressed for return to print the start screen
	je printStartScreen
	
	jmp waitForDataGoBackToStrat
	
printEndGameScreen:
	; Print the end game screen
	mov [currentFile], offset endGameScreen
	call printPic
	
	; Print the total points in the current game
	call printEndGameTotalPoints
	
	; Checks if the amount of points scored in this game is a new record
	mov ax, [gamePoints]
	; If the record is greater than the number of points scored in the current game print it
	; else print the number of points scored in the game
	cmp [bestPoints], ax
	ja printBestPoints
	
	mov [bestPoints], ax
	
printBestPoints:
	; Print the best points in all games
	call printEndGameBestPoints
	
waitForDataStartOverScoreTableOrExit:
	; Get input
	mov ah, 7h
	int 21h
	cmp al, 20h		; Space pressed for start the game over
	je printStartGameScreen
	cmp al, 74h		; t pressed for score table screen
	je printScoreTableScreen
	cmp al, 54h		; T pressed for score table screen
	je printScoreTableScreen
	cmp al, 1bh		; Escape pressed for exit the game
	je cleanup
	
	jmp waitForDataStartOverScoreTableOrExit
	
printScoreTableScreen:
	; Print the score table screen
	mov [currentFile], offset scoreTableScreen
	call printPic
	call printScroeTablePoints
	
	; Play move between screens sound
	mov ax, 7239 	; Mi
	call playSound
	
waitForDataGoBackToEndGame:
	; Get input
	mov ah, 7h
	int 21h
	cmp al, 1bh		; Escape pressed for return to the end game screen
	je playMoveBetweenScreensSound
	
	jmp waitForDataGoBackToEndGame
	
playMoveBetweenScreensSound:
	; Play move between screens sound
	mov ax, 7239 	; Mi
	call playSound
	jmp printEndGameScreen
	
cleanup:
	; Need to exit the game
	mov [startGame], 0
return:
	
ret
endp screens
	
;====================================================================================================
;											secondary Balls procs
;====================================================================================================

; Input - no parameters
; Output - print balls in random colors in the top of the screen
proc printRandomBalls
	; 01 = red, 02 = green, 03 = blue
	
	call getArrayOfTrheeRandomNumbers
	
; Print the left ball in the random color
; left ball
	; Check the first number in array and print the left ball in this color (01 = red, 02 = green, 03 = blue)
	cmp [randomBallsColorArray], 1
	je positionsOneNumberOne
	cmp [randomBallsColorArray], 2
	je positionsOneNumbertwo
	cmp [randomBallsColorArray], 3
	je positionsOneNumberTrhee
	
; Left ball number "01"
positionsOneNumberOne:
	mov [currentColorBall], offset redBall
	call printLeftBall
	
	jmp midBall
	
; Left ball number "02"
positionsOneNumbertwo:
	mov [currentColorBall], offset greenBall
	call printLeftBall
	
	jmp midBall
	
; Left ball number "03"
positionsOneNumberTrhee:
	mov [currentColorBall], offset blueBall
	call printLeftBall
	
; Check the second number in array and print the mid ball in this color (01 = red, 02 = green, 03 = blue)
midBall:
	; Check the second number in array and print the mid ball in this color (01 = red, 02 = green, 03 = blue)
	cmp [randomBallsColorArray + 1], 1
	je positionsTwoNumberOne
	cmp [randomBallsColorArray + 1], 2
	je positionsTwoNumberTwo
	cmp [randomBallsColorArray + 1], 3
	je positionsTwoNumberTrhee
	
; Mid ball number "01"
positionsTwoNumberOne:
	mov [currentColorBall], offset redBall
	call printMidBall
	
	jmp rightBall
	
; Mid ball number "02"
positionsTwoNumberTwo:
	mov [currentColorBall], offset greenBall
	call printMidBall
	
	jmp rightBall
	
; Mid ball number "03"
positionsTwoNumberTrhee:
	mov [currentColorBall], offset blueBall
	call printMidBall
	
; Check the third number in array and print the right ball in this color (01 = red, 02 = green, 03 = blue)
rightBall:
	; Check the third number in array and print the right ball in this color (01 = red, 02 = green, 03 = blue)
	cmp [randomBallsColorArray + 2], 1
	je positionsTrheeNumberOne
	cmp [randomBallsColorArray + 2], 2
	je positionsTrheeNumberTwo
	cmp [randomBallsColorArray + 2], 3
	je positionsTrheeNumberTrhee
	
; Right ball number "01"
positionsTrheeNumberOne:
	mov [currentColorBall], offset redBall
	call printRightBall
	
	jmp returnAfterPrintBalls
	
; Right ball number "02"
positionsTrheeNumberTwo:
	mov [currentColorBall], offset greenBall
	call printRightBall
	
	jmp returnAfterPrintBalls
	
; Right ball number "03"
positionsTrheeNumberTrhee:
	mov [currentColorBall], offset blueBall
	call printRightBall
	
returnAfterPrintBalls:
	
ret
endp printRandomBalls
	
;----------------------------------------------------------------------------------------------------
	
; Input - none
; Output - scroll lines 0 - 160 down
proc scrollDown
	doPush si, di, ds, cx, es
	
	mov ax, 0A000h
	mov es, ax
	
	mov si, 158*320+109	; From
	mov di, 159*320+109	; To
	mov cx, es
	; Point to screen area in es
	mov ds, cx
	; Number of lines to scroll down
	mov cx, 157
oneLine:
	push cx
	; Number of pixel in line
	mov cx, 120/2
	rep movsw
	sub si, 2*160+120
	sub di, 2*160+120
	pop cx
	loop oneLine
	
	;; Draw black line in top of screen
	;mov cx, 120/2		; Couner
	;; Put 0 (black) in ax
	;xor ax, ax
	;; Start line
	;mov di, 0
	;rep stosw
	
	; Insert the first line
	mov si, offset firstLine
	mov di, 109
	mov cx, 109
returnByte:
	mov al, [si]
	mov [es:di],al
	inc si
	inc di
	loop returnByte
	
	doPop es, cx, ds, di, si
ret
endp scrollDown
	
; Input - no parameters
; Output - take the first line of the road into firstLine variable
proc takeFirstLine
	doPush es,ax,si,di
	mov ax, 0A000h
	mov es, ax
	mov di, 109
	
	; Where to keep the line
	mov si, offset firstLine
	mov cx, 116
copyByte:
	mov al, [es:di]
	mov [si], al
	; Move to the next pixel
	inc di
	inc si
	loop copyByte
	
	doPop di,si,ax,es
ret
endp takeFirstLine
	
;----------------------------------------------------------------------------------------------------
	
; Input - gamePoints, lineToScrollDown
; Output - scrolls the screen faster and faster according to the number of points
proc scrollDownWithSpeed
	; In score 100 the speed will go to speed15
	cmp [gamePoints], 99
	ja speed15
	; In score 50 the speed will go to speed15
	cmp [gamePoints], 49
	ja speed12
	; In score 30 the speed will go to speed10
	cmp [gamePoints], 29
	ja speed10
	; In score 10 the speed will go to speed6 else the speed will be 3
	cmp [gamePoints], 9
	ja speed6
	
; Scroll down 4 lines
speed3:
	sub [lineToScrollDown], 4
	mov cx, 4
speed4Loop:
	call scrollDown
	loop speed4Loop
	jmp returnAfterScrollDownWithSpeed
	
; Scroll down 6 lines
speed6:
	sub [lineToScrollDown], 6
	mov cx, 6
speed6Loop:
	call scrollDown
	loop speed6Loop
	jmp returnAfterScrollDownWithSpeed
	
; Scroll down 10 lines
speed10:
	sub [lineToScrollDown], 10
	mov cx, 10
speed10Loop:
	call scrollDown
	loop speed10Loop
	jmp returnAfterScrollDownWithSpeed
	
; Scroll down 12 lines
speed12:
	sub [lineToScrollDown], 12
	mov cx, 12
speed12Loop:
	call scrollDown
	loop speed12Loop
	jmp returnAfterScrollDownWithSpeed
	
; Scroll down 15 lines
speed15:
	sub [lineToScrollDown], 15
	mov cx, 15
speed15Loop:
	call scrollDown
	loop speed15Loop
	
returnAfterScrollDownWithSpeed:
	
ret
endp scrollDownWithSpeed
	
;----------------------------------------------------------------------------------------------------
	
; Input - no parameters
; Output - delete the secondary balls
proc deleteBallsAfterScroll
	; The size of the rectangle
	mov [qb_width], 116
	mov [qb_height], 30
	
	; Position to take black rectangle
	mov [newPosition], 1*320+109
	
	; Take a black screen
	mov [currentScreenKeep], offset secondaryBallsBlackScreen
	call takeSquare
	
	; Position to return black rectangle
	mov [oldPosition], 130*320+109
	; The secondary balls are deleted after they reach the main ball
	call returnSquare
ret
endp deleteBallsAfterScroll
	
;====================================================================================================
;											Balls Color procs
;====================================================================================================
	
; Input - mainBallColor, randomBallsColorArray
; Output - if the color are not the same mov to isSameColor 1 else add one point
proc checkIsSameColor
	; Reset bh
	xor bh, bh
	mov bl, [currentRoadNumber]
	; si = currentRoadNumber
	mov si, bx
	
	cmp [mainBallColor], offset redBall
	je redCallMoveCharacter
	cmp [mainBallColor], offset greenBall
	je greenCallMoveCharacter
	; If not red and not green it must be blue ball
	jmp blueCallMoveCharacter
	
redCallMoveCharacter:
	; If the color found in the color array instead of the ball is equal to the color of the ball go to ballsInTheSameColor
	cmp [randomBallsColorArray + si - 1], 1
	je ballsInTheSameColor
	; Else go to isNotSameColor
	jmp isNotSameColor

greenCallMoveCharacter:
	; If the color found in the color array instead of the ball is equal to the color of the ball go to ballsInTheSameColor
	cmp [randomBallsColorArray + si - 1], 2
	je ballsInTheSameColor
	; Else go to isNotSameColor
	jmp isNotSameColor
	
blueCallMoveCharacter:
	; If the color found in the color array instead of the ball is equal to the color of the ball go to ballsInTheSameColor
	cmp [randomBallsColorArray + si - 1], 3
	je ballsInTheSameColor
	; Else go to isNotSameColor
	jmp isNotSameColor
	
ballsInTheSameColor:
	; Play add points sound
	mov ax, 6087 	; Sol
	call playSound
	
	; Add one point to gamePoints
	inc [gamePoints]
	; Prints the new number of points
	call printInGamePoints
	; Checks if the color of the ball needs to be changed
	call checkChangeColorMainBall
	; The balls are in the same color
	mov [isSameColor], 0
	jmp returnAftercheckIsSameColor
	
isNotSameColor:
	; The balls are not in the same color
	mov [isSameColor], 1
	
	; Play game over sound
	mov cx, 3
gameOverSoundLoop:
	mov ax, 9121 	; Do
	call playSound
	doPush cx
	; Delay 5 ticks
	mov cx, 5
delayBetweenOneSoundLoop:
	call delayProc
	loop delayBetweenOneSoundLoop
	doPop cx
	loop gameOverSoundLoop
	
returnAftercheckIsSameColor:
	
ret
endp checkIsSameColor
	
;----------------------------------------------------------------------------------------------------
	
; Input - gamePoints
; Output - change the main ball color every 3 points
proc checkChangeColorMainBall
	; Resets ah
	xor ah, ah
	mov ax, [gamePoints]
	mov bl, 3
	div bl			; ah = remainder
	
	; If the remainder of gamePoints/3 = 0, the color of the main ball should be changed, else return
	cmp ah, 0
	jne returnAfterChangeMainBallColor
	
	cmp [mainBallColor], offset redBall
	je mainBallIsRed
	cmp [mainBallColor], offset greenBall
	je mainBallIsGreen
	; If the main ball is not red or green so it must be blue
	jmp mainBallIsBlue
	
mainBallIsRed:
	; Saves the color of the main ball in dl
	mov dl, 1
	jmp getOneRandomNumber

mainBallIsGreen:
	; Saves the color of the main ball in dl
	mov dl, 2
	jmp getOneRandomNumber

mainBallIsBlue:
	; Saves the color of the main ball in dl
	mov dl, 3
	
getOneRandomNumber:
	; Get random number from 1 - 3 into al
	call getRandomNumberFromOneToTrhee
	; Getting new number until getting a different color from current color
	cmp dl, al
	je getOneRandomNumber
	
	cmp al, 1
	je red
	cmp al, 2
	je green
	; Not red or green so it must be blue
	jmp blue
	
red:
	; Change the color of the ball to red
	mov [mainBallColor], offset redBall
	jmp callMoveCharacterAfterUpdateTheColor
	
green:
	; Change the color of the ball to green
	mov [mainBallColor], offset greenBall
	jmp callMoveCharacterAfterUpdateTheColor
	
blue:
	; Change the color of the ball to blue
	mov [mainBallColor], offset blueBall
	
; Print the new main ball with diffrent color
callMoveCharacterAfterUpdateTheColor:
	call moveCharacter	
	
returnAfterChangeMainBallColor:
	
ret
endp checkChangeColorMainBall
	
;====================================================================================================
;											Print Secondary Balls procs
;====================================================================================================
	
; Input - position and color of the ball
; Output - print the left ball in the input color
proc printLeftBall
	; Startin pos left ball
	mov [oldPosition], 10*320+109
	mov [newPosition], 10*320+109
	
	; The size of the square
	mov [qb_width], 30
	mov [qb_height], 30
	
	; The color of the ball
	mov ax, [currentColorBall]
	mov [currentBall], ax
	
	; Print the ball in the current position, size and color
	call printBall
	
ret
endp printLeftBall
	
;----------------------------------------------------------------------------------------------------
	
; Input - position and color of the ball
; Output - print the mid ball in the input color
proc printMidBall
	; Startin pos mid ball
	mov [oldPosition], 10*320+152
	mov [newPosition], 10*320+152
	
	; The size of the square
	mov [qb_width], 30
	mov [qb_height], 30
	
	; The color of the ball
	mov ax, [currentColorBall]
	mov [currentBall], ax
	
	; Print the ball in the current position, size and color
	call printBall
	
ret
endp printMidBall
	
;----------------------------------------------------------------------------------------------------
	
; Input - position and color of the ball
; Output - print the right ball in the input color
proc printRightBall
	; Startin pos right ball
	mov [oldPosition], 10*320+195
	mov [newPosition], 10*320+195
	
	; The size of the square
	mov [qb_width], 30
	mov [qb_height], 30
	
	; The color of the ball
	mov ax, [currentColorBall]
	mov [currentBall], ax
	
	; Print the ball in the current position, size and color
	call printBall
	
ret
endp printRightBall
	
;====================================================================================================
;											Print Points procs
;====================================================================================================
	
; Input - x, y, currentPoints, currentPointsColor
; Output - print the points
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
	
;----------------------------------------------------------------------------------------------------
	
; Input - no parameters
; Output - print the points in the game screen
proc printInGamePoints
	; Position of the points
	mov [x], 9
	mov [y], 2
	; Points to print
	mov ax, [gamePoints]
	mov [currentPoints], ax
	; White color
	mov [currentPointsColor], 7
	call printPoints
ret
endp printInGamePoints
	
;----------------------------------------------------------------------------------------------------
	
; Input - no parameters
; Output - print the total points in end game screen
proc printEndGameTotalPoints
	; Position of the points
	mov [x], 23
	mov [y], 7
	; Points to print
	mov ax, [gamePoints]
	mov [currentPoints], ax
	; Green color
	mov [currentPointsColor], 2
	call printPoints
ret
endp printEndGameTotalPoints
	
;----------------------------------------------------------------------------------------------------
	
; Input - no parameters
; Output - print the best points in end game screen
proc printEndGameBestPoints
	; Position of the points
	mov [x], 23
	mov [y], 15
	; Points to print
	mov ax, [bestPoints]
	mov [currentPoints], ax
	; Green color
	mov [currentPointsColor], 2
	call printPoints
ret
endp printEndGameBestPoints
	
;====================================================================================================
;											Speaker procs
;====================================================================================================
	
; Input - the frequency divisor inside AX register
; Output - play the sound in the frequency
proc playSound
	; Start the speaker
	startSpeaker
	
	out 42h, al	; sending lower byte
	mov al, ah
	out 42h, al	; sending upper byte
	
	call delayProc
	
	; End the speaker
	endSpeaker
ret
endp playSound
	
;----------------------------------------------------------------------------------------------------
	
; Input - delay
; Output - delay one tick
proc delayProc
	doPush ax
	
	; Takes the current time in al and puts it in prevTimeDelay
	takeTime
	mov [prevTimeDelay], ax
	
delayLoop:
	; Takes the current time in al and checks if it is equal to the previous time
	takeTime
	; If the current time is equal to the previous time we wait until the time changes else we update the current time
	cmp [prevTimeDelay], ax
	je delayLoop
	mov [prevTimeDelay], ax
	mov [delay], 1
	
	doPop ax
ret
endp delayProc
	
;====================================================================================================
;											Score Table procs
;====================================================================================================

; Input – filehandle, Header
; Output - read BMP file header, 54 bytes
proc readTable
	mov ah, 3fh
	mov bx, [filehandle]
	mov cx, 3		; Read 3 bytes
	mov dx, offset bestScore
	int 21h
ret
endp readTable
	
;----------------------------------------------------------------------------------------------------
	
; Input - filehandle
; Output - write 3 bytes to the file from bestScore
proc writeTable
	mov ah, 40h
	mov bx, [filehandle]
	mov cx, 3		; Write 3 bytes
	mov dx, offset bestScore
	int 21h
ret
endp writeTable
	
;----------------------------------------------------------------------------------------------------
	
; Input – bestScore 
; Output - sort the places from small to large in score table in bestScore array
proc sortScoreTable
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
	mov [bestScore], al			; Third place
	mov [bestScore + 1], ah		; Second place
	mov [bestScore + 2], bh		; First place
	
	; Updates the places according to the array
	mov [firstPlace], bh
	mov [secondPlace], ah
	mov [thirdPlace], al
	
ret
endp sortScoreTable
	
;----------------------------------------------------------------------------------------------------
	
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
	
;----------------------------------------------------------------------------------------------------
	
; Input - gamePoints
; Output - checks if the record should enter the table and inserts it if necessary
proc checkIfShouldEnterScoreTable
	; Initialize
	mov bx, [gamePoints]
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
	
;----------------------------------------------------------------------------------------------------
	
; Input - no parameters
; Output - read the score table file and sort the best scores and update the file to the best scores
proc scoreTableProc
	mov [currentFile], offset scoreTable
	call openFile
	call readTable
	call closeFile
	call sortScoreTable
	call checkIfShouldEnterScoreTable
	call openFile
	call writeTable
	call closeFile
ret
endp scoreTableProc
	
;----------------------------------------------------------------------------------------------------
	
; Input - no parameters
; Output - print the points in the score table
proc printScroeTablePoints
	call printFirstPlace
	call printSecondPlace
	call printThirdPlace
ret
endp printScroeTablePoints
	