[org 0x0900]
[bits 16]

; Memory Layout
; 0x00500 - 0x07E00: kernel code
; 0x07E00 - 0x70000: heap
; 0x70000 - 0x7FFFF: kernel stack

%include "src/start.inc"
%include "src/data.inc"
%include "src/int10.inc"
%include "src/int16.inc"
%include "src/str.inc"

ping_code:
    push si
    push cx
    mov si, ping_str
    mov cx, ping_str_other_len
    call print_string_cursor
    call newline
    pop cx
    pop si
    ret

print_prompt:
    push cx
    push si

    mov si, prompt
    mov cx, [prompt_len]
    call print_string_cursor

    pop si
    pop cx
    ret

; si: word str, 0 end
; bp: first word addr
; es: first word DS
pword:
    push bp
    push di
    push ax
    push bx
    push ecx

    mov ax, ds
    mov bx, es
.loop:

    push si
    mov ds, bx
    mov es, WORD [bp]
    mov di, WORD [bp+2]
    mov ds, ax
    call strcmp
    jz .found
    pop si

    mov ds, bx

    mov ecx, DWORD [bp+4]
    cmp ecx, 0x0
    je .not_found

    mov bx, [bp+4]
    mov bp, [bp+6]

    jmp .loop
.found:
    mov ds, bx
    call FAR [bp+8]
    jmp .end
.not_found:
.end:
    mov ds, ax
    pop ecx
    pop bx
    pop ax
    pop di
    pop bp
    ret

command:
    push ax
    push bx
    push si
    push di
    push bp
    push es

    mov si, input_buffer
    mov di, si
    mov bx, 0x20

    cld
.loop:
    lodsb
    cmp al, 0
    je .word

    cmp al, 0x20 ; ' '
    jne .next
    cmp al, bl
    je .same
    mov BYTE [si - 1], 0
    jmp .word

    jmp .loop
.next:
    mov bl, al
    jmp .loop
.word:
    cmp bl, 0x20
    je .end

    push si
    push bx
    mov si, di
    mov bp, WORD [first_word+2]
    mov bx, 0
    mov es, bx
    pop bx

    call pword
    pop si

    cmp al, 0
    je .end

    mov bx, 0x20
    mov di, si

    jmp .loop
.same:
    inc si
    mov di, si
    jmp .loop
.end:
    pop es
    pop bp
    pop di
    pop si
    pop bx
    pop ax
    ret



