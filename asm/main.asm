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
    extern framebuffer
    mov ax,framebuffer
    mov es,ax
    mov cx,1
    mov di,0
    
    framebuffer_loop:
        mov es:[di],cl
        inc cx
        cmp cx,5
        jb cx_dont_reset
            mov cx,1
        cx_dont_reset:
        inc di
        cmp di,320 * 200
        jb framebuffer_loop

    extern vga_flip
    call vga_flip
    
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
    resb 1024
_stack: ; stack grows downwards