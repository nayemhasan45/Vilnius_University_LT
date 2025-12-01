.model tiny
.code
org 100h

start:

    ; ---- 1) Surname + Name twice (lines 2 & 3) ----
    mov ah,09h
    mov dx,offset part1
    int 21h

    ; ---- 2) Name three times at column 10, lines 10–12 ----
    mov ah,09h
    mov dx,offset part2
    int 21h

    ; ---- 3) Surname once at column 13, line 17 ----
    mov ah,09h
    mov dx,offset part3
    int 21h

    ret

;---------------- Data block -----------------------
.data
; 1) after 1 blank line, print twice
part1 db 0Dh,0Ah
      db 'AL AMIN HOSSAIN NAYEM',0Dh,0Ah
      db 'AL AMIN HOSSAIN NAYEM',0Dh,0Ah,'$'

; 2) move to line 10 and indent 9 spaces (column 10) each time
part2 db 0Ah,0Ah,0Ah,0Ah,0Ah,0Ah,0Ah   ; skip down to line 10
      db '         NAYEM',0Dh,0Ah
      db '         NAYEM',0Dh,0Ah
      db '         NAYEM',0Dh,0Ah,'$'

; 3) skip to line 17 and indent 12 spaces (column 13)
part3 db 0Ah,0Ah,0Ah,0Ah    ; from line 13 to 17
      db '            AL AMIN HOSSAIN',0Dh,0Ah,'$'

end start
