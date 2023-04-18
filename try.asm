include macro.asm
IDEAL
MODEL small
STACK 100h
DATASEG

filename db 'testfile.txt',0
filehandle dw ?
Message db 'Hello world!'
ErrorMsg db 'Error', 10, 13,'$'
NumOfBytes dw 13

CODESEG
proc OpenFile
; Open file for reading and writing
mov ah, 3Dh
mov al, 2
mov dx, offset filename
int 21h
jc openerror
mov [filehandle], ax
ret
openerror:
mov dx, offset ErrorMsg
mov ah, 9h
int 21h
ret
endp OpenFile
proc WriteToFile
; Write message to file
mov ah,40h
mov bx, [filehandle]
mov cx,12
mov dx,offset Message
int 21h
ret
endp WriteToFile
proc CloseFile
       doPush ax,bx
; Close file
mov ah,3Eh
mov bx, [filehandle]
int 21h
doPop bx,ax
ret
endp CloseFile
proc ReadFile
doPush ax,bx,cx,dx
; Read file
mov ah,3Fh
mov bx,[filehandle]
mov cx,[NumOfBytes]
mov dx,offset filename
int 21h
doPop dx,cx,bx,ax
ret
endp ReadFile


start:
mov ax, @data
mov ds, ax
; Process file
call OpenFile
call WriteToFile
see:
call ReadFile
 ;mov ah,7h
 ;int 21h
;call CloseFile

exit:
mov ax, 4c00h
int 21h
END start

