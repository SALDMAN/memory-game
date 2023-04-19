	; for file:
    filehandle	dw	?
	ErrorMsg	db	'Error', 13, 10,'$';if it cannot open the file there will be eror message
	; for BMP:
    Header		db	54 dup (0)
    Palette		db	256*4 dup (0)		;because 256 colors, every color is 4 bytes
    ScrLine		db	320 dup (0)
	picHigh	dw	(?)					;height of picture
	picWidth		dw	(?)					;width of picture
	left		dw	(?)					;add from left side = X
	top			dw	(?)					;add from top side  = Y
	oldPos		dw	(?)					;last placof the picture
	newPos		dw	(?)					;set new positon of the picture	
	lost db "sorry but it is seems that you have lost"
	score db 0
	is db 0
	hourtxt 		db 	'Hour:     ','$'
	mintxt			db	13,10,'Mins:     ','$'
	sectxt		db	13,10,'Sec:      ','$'
	mstxt		db	13,10,'1/100sec: ','$'
	savetime	dw	?
	divisorTable	db	10,1,0

	open	    db	'open.bmp',0		;open picture
	instraction db 'inst.bmp',0;instraction picture
    lose        db	'lose.bmp',0		;loose picture
    bonus       db	'bonus.bmp',0		;bonus picture
	
	key			db   ? 					;0=nokey,1=left,2=right,3=esc
	Buffer		db	48*3 dup	(?)			;array that file will be copied into. 48*3 because 3 lines which each's length is 48 bytes 
	scrKeep		db	48*3 dup (?)
	Clock 		equ es:6Ch
	ticks		dw ?
	oldTime		dw ?
	StartMessage 	db 13,10,'Counting 30 seconds. Start...',13,10,'$'
	EndMessage 	db 13,10,'...Stop.',13,10,'$'
	StartMessage2 db 13,10,'counting 10 seconds. start...',13,10,'$'
    counter db 0
	Clock equ es:6Ch
	word1  db "hello there$"
	word2  db "Incomprehensibility$"
	word3  db "trichotillomania$"
	word4  db "switch case$"
	word5  db "very hard word$"
	word6  db "uncopyrightable$"
	word7  db "remember me$"
	word8  db "computer science$"
	word9  db "shenanigans$"
    word10 db "bamboozle$"
	word11 db "who are you?$"
	word12 db "bodacious$"
	word13 db "brouhaha$"
	word14 db "canoodle$"
	word15 db "nincompoop$"
	word16 db "phalanges$"
	word17 db "taradiddle$"
	word18 db "macaronic$";
	word19 db "absquatulate$"
	word20 db "batholith$"
	word21 db "godwottery$"
	word22 db "spondulicks$"
	word23 db "impignorate$"
	word24 db "everywhen$"
	word25 db "widdershins$"
	word26 db "collywobbles$";
	word27 db "abibliophobia$"
	word28 db "impignorate$"
	word29 db "bumbershoot$"
	word30 db "flibbertigibbet$"
	word31 db "pandiculation$"
	word32 db "erinaceous$"
	choose db 0
    String db 100 dup(?)
	countSt	db 0
	scoreTable					db 'name.txt',0
	bestScore					db 3 dup (?)
	currentFile					dw ?
	pressEnter db 0 ; 0-no enter, 1=enter
	selectedWord dw ?
	seletedWordLen	db ?
	correct db ? ; 0=correct, 1= nocorect
	wrong db 0
	combo db 0
	count db 0
	massage db 13,10,'the word is:',13,10,'$'
	note  dw 0ac9h; 1193180/432-> (hex)
	tell db 13,10,'wrong try again...',13,10,'$'
	was  db 33 ; a very big num for the begining because the random is bettwen 0-31
	points dw 0
	;Points Variables
	isSameColor	db 0
	gamePoints	dw 0
	bestPoints	dw 0
	x			db ?	; Column
	y		    db ?	; Row
  currentPoints dw 0
  currentPointsColor db ?
	digitsCount	db 0
	tempPoints	dw 0
	
	; Score Table Variables
	firstPlace	db 0
	secondPlace db 0
	thirdPlace	db 0
