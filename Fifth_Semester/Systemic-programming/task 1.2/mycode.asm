;-------------------------------------------------------------
; Draw a big letter 'T' from your name letters
; Name: al amin hossain nayem
; Start position: Row 10, Column 5
; Width: 11 chars, Height: 15 lines
; Only MS-DOS int 21h calls
;-------------------------------------------------------------

org 100h                 ; COM program entry

.data
; Name letters without spaces, repeated to fill 11 + 14 = 25 chars
letters db 'ALAMINHOSSAINNAYEMALAMINH$'

.code
start:
    mov ax, @data
    mov ds, ax

    ; --- move down to line 10 (9 newlines) ---
    mov cx, 9
down_loop:
    mov ah, 02h
    mov dl, 13       ; CR
    int 21h
    mov dl, 10       ; LF
    int 21h
    loop down_loop

    ; --- move right to column 5 (4 spaces) ---
    mov cx, 4
right_loop:
    mov ah, 02h
    mov dl, ' '
    int 21h
    loop right_loop

    ; --- print top horizontal bar (11 letters) ---
    mov si, 0
    mov cx, 11
top_bar:
    mov ah, 02h
    mov dl, [letters + si]
    int 21h
    inc si
    loop top_bar

    ; --- print vertical stem (14 lines) ---
    mov bx, 0        ; line counter
stem_lines:
    cmp bx, 14
    je  done

    ; new line
    mov ah, 02h
    mov dl, 13
    int 21h
    mov dl, 10
    int 21h

    ; move to column 10 (9 spaces)
    mov cx, 9
stem_spaces:
    mov ah, 02h
    mov dl, ' '
    int 21h
    loop stem_spaces

    ; print next letter
    mov ah, 02h
    mov dl, [letters + si]
    int 21h
    inc si
    inc bx
    jmp stem_lines

done:
    mov ax, 4C00h
    int 21h
