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
	oldPos		dw	(?)					;last place of unicorn
	newPos		dw	(?)					;new place of unicorn
	left1		dw	(?)					;the X of cloud number 1	
	top1		dw	(?)					;the Y of cloud number 1	
	left2		dw	(?)					;the X of cloud number 2	
	top2		dw	(?)					;the Y of cloud number 2	
	left3		dw	(?)					;the X of cloud number 3	
	top3		dw	(?)					;the Y of cloud number 3	
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
	instraction db 'onl.bmp',0;instraction picture
    lose        db	   'lose.bmp',0		;picture of unicorn figure
	game 		db	'game.bmp',0		;picture for deleted things
	
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
	points db 0
	Clock 	equ es:6Ch
	word1 db "hello world$"
	word2 db "hello man$"
	word3 db "hello niga$"
	word4 db "hello kobi$"
	word5 db "hello amos$"
	word6 db "hello renji$"
	word7 db "hello ben$"
	word8 db "hello yonatan$"
	word9 db "hello renshets$"
	word10 db "hello rer$"
	word11 db "hello res$"
	word12 db "hello de$"
	word13 db "hello as$"
	word14 db "hello aw$"
	word15 db "hello ac$"
	word16 db "hello az$"
	word17 db "hello ai$"
	wordstable dw offset word1,offset word2,offset word3,offset word4,offset word5,offset word6,offset word7,offset word8,offset word9,offset word10,offset word11,offset word12,offset word13,offset word14,offset word15,offset word16,offset word17
	wordsLen db 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5
	choose db 0
	wrong db 0
    String db 100 dup(?)
	countSt	db 0
	pressEnter db 0 ; 0-no enter, 1=enter
	selectedWord dw ?
	seletedWordLen	db ?
	correct db ? ; 0=correct, 1= nocorect