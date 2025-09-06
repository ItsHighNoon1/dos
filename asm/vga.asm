global vga_enable
global vga_disable

segment code
vga_enable:
    mov ax,0x0013 ; "mode 13"
    int 10h
    ret

vga_disable:
    mov ax,0x0003 ; default mode
    int 10h
    ret
