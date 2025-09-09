; move specified number of bytes from ds to es.
; CLOBBERS: SI, DI, CX
%macro zfmov 1
    cld
    mov si,0
    mov di,0
    mov cx,%1
    test cx,1
    jz %%even
        ; moving an odd number of bytes, do 1 movsb
        movsb
        dec cx
%%even:
    ; rep executes cx times, but each movsw does 2 bytes. divide by 2
    shr cx,1
    rep movsw
%endmacro