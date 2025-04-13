[org 0x0700]
[bits 16]

start:
    ; load kernel
    mov ah, 0x02
    mov al, [0x0502]
    mov ch, 0
    mov cl, 4
    mov dh, 0
    mov bx, 0x0900
    int 0x13

    jmp 0x0000:0x0900

times 512 - ($ - $$) db 0
