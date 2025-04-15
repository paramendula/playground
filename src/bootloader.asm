[org 0x7C00]
[bits 16]
[cpu 8086]

start:
    mov ax, 0
    mov ds, ax
    mov es, ax

    ; read options + loader
    mov ah, 0x02
    mov al, 2
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov bx, 0x0500
    int 0x13

    jmp 0x0000:0x0700

times 510 - ($ - $$) db 0
dw 0xAA55
