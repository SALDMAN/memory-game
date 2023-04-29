	; for file:
    filehandle	dw	?
	ErrorMsg	db	'Error', 13, 10,'$';if it cannot open the file there will be eror message
	; for BMP:
    Header		db	54 dup (0)
    Palette		db	256*4 dup (0)		;because 256 colors, every color is 4 bytes
    ScrLine		db	320 dup (0)
	picHigh	    dw	(?)					;height of picture
	picWidth	dw	(?)					;width of picture
	left		dw	(?)					;add from left side = X
	top			dw	(?)					;add from top side  = Y
	oldPos		dw	(?)					;last placof the picture
	newPos		dw	(?)			;set new positon of the picture	

	open	    db	'open.bmp',0		;open picture
	instraction db 'inst.bmp',0;instraction picture
    lose        db	'lose.bmp',0		;loose picture
    bonus       db	'bonus.bmp',0		;bonus picture
	
	
	Buffer		db	48*3 dup	(?)			;array that file will be copied into. 48*3 because 3 lines which each's length is 48 bytes 
	Clock 		equ es:6Ch
	ticks		dw ?
	oldTime		dw ?
	StartMessage db 13,10,'Counting 30 seconds. Start...',13,10,'$'
	StartMessage2 db 13,10,'counting 10 seconds. start...',13,10,'$'
	Clock      equ es:6Ch
	word1  db "nonplussed$"
	word2  db "incomprehensibility$"
	word3  db "trichotillomania$"
	word4  db "disinterested$"
	word5  db "abrogate$"
	word6  db "uncopyrightable$"
	word7  db "blandishment$"
	word8  db "camaraderie$"
	word9  db "shenanigans$"
    word10 db "bamboozle$"
	word11 db "anachronistic$"
	word12 db "bodacious$"
	word13 db "brouhaha$"
	word14 db "canoodle$"
	word15 db "nincompoop$"
	word16 db "phalanges$"
	word17 db "taradiddle$"
	word18 db "macaronic$"
	word19 db "absquatulate$"
	word20 db "batholith$"
	word21 db "godwottery$"
	word22 db "spondulicks$"
	word23 db "impignorate$"
	word24 db "everywhen$"
	word25 db "widdershins$"
	word26 db "collywobbles$"
	word27 db "abibliophobia$"
	word28 db "enormity$";
	word29 db "bumbershoot$"
	word30 db "flibbertigibbet$"
	word31 db "pandiculation$"
	word32 db "erinaceous$"
	choose     db 0
    String     db 100 dup(?)
	countSt	   db 0
	pressEnter db 0 ; 0-no enter, 1=enter,2= esc
	selectedWord dw ?
	seletedWordLen db ?
	correct    db ? ; 0=correct, 1= nocorect
	wrong      db 0
	combo      db 0
	count      db 0
	massage    db 13,10,'the word is:',13,10,'$'
	note       dw 0ac9h; 1193180/432-> (hex)
	tellwrong       db 13,10,'wrong try again...',13,10,'$'
	was        db 33 ; a very big num for the begining because the random is bettwen 0-31
