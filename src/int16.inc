
; -> ah: bios scan node
;    al: ascii character
get_key:
    mov ah, 0
    int 0x16
    ret

; zf set if no keystroke available
; zf clear if keystroke available
; -> ah?: bios scan code
;    al?: ascii character
check_key:
    mov ah, 01h
    int 0x16
    ret
