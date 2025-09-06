section .text
global _start
global _exit

segment code
_start:
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    mov sp,_stack

    ; print a debug message nobody will ever see
    ; because we immediately mode switch
    mov dx,msg_init
    mov ah,9
    int 0x21

    ; enter vga mode
    extern vga_enable
    call vga_enable

    mov dx,msg_test
    mov ah,9
    int 0x21

epic_loop:
    mov ax,0xa000
    mov es,ax
    mov cx,255
    mov di,320*200
    busy_loop:
        dec cx
        dec cx
        dec cx
        dec cx
        dec cx
        dec di
        jnz busy_loop
    mov cx,255
    mov di,320*200
    framebuffer_loop:
        mov es:[di],cl
        dec cx
        jnz cx_dont_reset
            mov cx,255
        cx_dont_reset:
        dec di
        jnz framebuffer_loop
    mov cx,255
    mov di,320*200
    framebuffer_loop2:
        mov es:[di],ch
        dec di
        jnz framebuffer_loop2
    jmp epic_loop

_exit:
    ; exit vga mode
    extern vga_disable
    call vga_disable

    ; message saying we got here
    mov dx,msg_exit
    mov ah,9
    int 0x21

    ; exit syscall
    mov ax,0x4c00
    int 0x21

segment data
    msg_init db "started game", 13, 10, '$'
    msg_test db "ABCDEF", 13, 10, '$'
    msg_exit db "stopped game", 13, 10, '$'

segment stack stack
    resb 256
_stack: