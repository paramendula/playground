[org 0x0900]
[bits 16]
[cpu 8086]

; Memory Layout
; 0x00500 - 0x07E00: kernel code
; 0x07E00 - 0x70000: heap
    ; 0x07E00 - 0x17E00: programming stack
    ; 0x17E00 - 0x70000: programming heap
; 0x70000 - 0x7FFFF: kernel stack

%include "src/macro.inc"

section .text
%include "src/start.inc"
%include "src/data.inc"
section .text
%include "src/pstack.inc"
%include "src/words/words.inc"
%include "src/int10.inc"
%include "src/int16.inc"
%include "src/str.inc"

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
; bx: first word addr
; es: first word DS
pword:
    push di
    push ax
    push bx
    push cx
    push dx

    mov ax, ds
    mov dx, es
.loop:
    push si
    mov ds, dx
    mov es, WORD [bx+2]
    mov di, WORD [bx]

    mov ds, ax

    call strcmp
    jz .found
    pop si

    mov ds, dx

    mov cx, WORD [bx+4]
    cmp cx, 0x0
    je .check_segment
    jmp .all_good
.check_segment:
    mov cx, WORD [bx+6]
    cmp cx, 0x0
    je .not_found
.all_good:
    mov dx, WORD [bx+6]
    mov bx, WORD [bx+4]

    jmp .loop
.found:
    pop si
    mov ds, dx
    call FAR [bx+8]
    jmp .end
.not_found:
.end:
    mov ds, ax
    pop dx
    pop cx
    pop bx
    pop ax
    pop di
    ret

command:
    push ax
    push bx
    push cx
    push si
    push di
    push bp
    push es
    push dx

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

    ;; atoi
    mov bx, 10
    call atoi

    cmp dx, 0
    jne .not_number
    push ax
    mov ax, cx
    call pstack_push_ax

    pop ax
    jmp .then
.not_number:
    mov si, di
    ;; pword
    push es
    mov bx, WORD [first_word+2]
    mov es, bx
    mov bx, WORD [first_word]

    call pword

    pop es
.then:
    pop bx
    pop si
    ;;

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

    pop dx
    pop es
    pop bp
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret



