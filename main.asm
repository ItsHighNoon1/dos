format mz

segment .code
start:
;   reg ds needs to point to the data segment
    mov ax,dat.data
    mov ds,ax
;   set video mode
    mov ah,00h
    mov al,13h
    int 10h
;   draw pixel
    mov ah,0ch
    mov cx,160
    mov dx,100
    mov al,4
    int 10h
;   wait for keypress
    mov ah,00h
    int 16h
;   return to text video mode
    mov ah,00h
    mov al,03h
    int 10h
;   print hello world
    mov dx,hello
    mov ah,9
    int 0x21
    mov ax,0x4c00
    int 0x21

dat:
segment .data
hello:  db  "hello, world", 13, 10, "$"