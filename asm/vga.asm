%include "zfmov.inc"

global framebuffer

segment data
    framebuffer resb framebuffer_len
    framebuffer_len equ 320 * 200

global vga_enable
global vga_disable
global vga_flip

segment code

; enable vga mode 0x13 via bios interrupt. this mode is the easiest one for
; me to draw to.
; PARAMS - NONE
vga_enable:
    push ax

    mov ax,0x0013 ; "mode 13"
    int 10h

    pop ax
ret

; enable vga mode 0x3 via bios interrupt. this is the default mode dos runs
; in so we do this switch when we are done with the game.
; PARAMS - NONE
vga_disable:
    push ax

    mov ax,0x0003 ; default mode
    int 10h

    pop ax
ret

; flip the back buffer to the front buffer. results in screen tearing but that
; beats flickering and triple buffering is too expensive (lol?)
; by the way, this is WAY faster than writing direct to vga memory. which
; makes sense but i didnt expect dosbox to slow me down that hard
; PARAMS - NONE
vga_flip:
    push ax
    push cx ; clobbered by zfmov
    push ds
    push es
    push si ; clobbered by zfmov
    push di ; clobbered by zfmov

    mov ax,framebuffer
    mov ds,ax
    mov ax,0xa000
    mov es,ax
    zfmov framebuffer_len
    
    pop di
    pop si
    pop es
    pop ds
    pop cx
    pop ax
ret