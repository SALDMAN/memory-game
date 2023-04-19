


	; Screens Variables
	startScreen					db 'startSc.bmp',0
	instructionsScreen			db 'instSc.bmp',0
	gameScreen					db 'gameSc.bmp',0
	endGameScreen				db 'endSc.bmp',0
	startGame					db ?
	filehandle					dw ?
	Header						db 54 dup (0)
	Palette						db 256*4 dup (0)
	ScrLine						db 320 dup (0)
	ErrorMsg					db 'Error', 13, 10,'$'
	currentFile					dw ?
	leftGap						dw 0
	topGap						dw 0
	picHigh						dw 200
	picWidth					dw 320
	
	; General Variables
	qb_width					dw 30
	qb_height					dw 30
	oldPosition					dw 160*320+152		; Last place of qbert
	newPosition					dw 160*320+152		; New place of qbert
	currentBall					dw ?
	currentColorBall			dw ?
	currentScreenKeep			dw ?
	
	; Main Ball Variables
	oldPositionMainBall			dw (?)		; Last place of qbert of main ball
	newPositionMainBall			dw (?)		; New place of qbert of main ball
	mainBallScreenKeep			db 30*30 dup (?)
	mainBallColor				dw ?
	currentRoadNumber			db 2		; The main ball start position
	
	; secondary Balls Variables
	secondaryBallsBlackScreen	db 30*116 dup (?)
	lineToScrollDown			db 120			; Number of lines to scroll down
	firstLine					db 120 dup (?)
	
	; Random Variables
	Clock						equ es:6Ch		; The place of the clock in the memory
	divisorTable				db 10,1,0
	randomBallsColorArray		db 3 dup (?)
	
	; Timer Variables
	prevTime					dw ?
	ticks						db 1
	prevTimeDelay				dw ?
	delay						db 1
	
	;Points Variables
	isSameColor					db 0
	gamePoints					dw 0
	bestPoints					dw 0
	x							db ?	; Column
	y							db ?	; Row
	currentPoints				dw 0
	currentPointsColor			db ?
	digitsCount					db 0
	tempPoints					dw 0
	
	; Score Table Variables
	scoreTable					db 'table',0
	scoreTableScreen			db 'tableSc.bmp',0
	bestScore					db 3 dup (0)
	firstPlace					db 0
	secondPlace 				db 0
	thirdPlace					db 0
	
	


	


