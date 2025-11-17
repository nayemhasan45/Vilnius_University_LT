; TEXT CLOCK PROGRAM
; Shows letters of your NAME one by one in the same place every second.
; After every 60 seconds, shows your SURNAME + minutes passed.
; Program stops when you press Q or q.

.model  tiny
.code
org     100h

start:
    ; Make sure DS = CS (needed to access data in TINY model COM program)
    push    cs
    pop     ds

    ; Set video mode 3 (80x25 color text)
    mov     ah, 0
    mov     al, 3
    int     10h

    ; Clear the whole screen (scroll up with blank spaces)
    mov     ax, 0600h        ; AH=06h: scroll, AL=0: clear all lines
    mov     bh, 07h          ; attribute: white on black
    mov     cx, 0000h        ; upper-left corner (row 0, col 0)
    mov     dx, 184Fh        ; lower-right corner (row 24, col 79)
    int     10h

    ; Initialize counters and index
    mov     secCount, 0      ; seconds in current minute = 0
    mov     minCount, 0      ; minutes passed = 0
    mov     nameIdx,  0      ; index into name string = first character

    ; Read current time once to set previous second value
    mov     ah, 2Ch          ; DOS function: get current time
    int     21h              ; CH=hour, CL=minute, DH=second, DL=1/100 sec
    mov     prevSec, dh      ; store current seconds as previous

main_loop:

    ; ------------------------------------------------
    ; 1. Check if a new second has started
    ; ------------------------------------------------
    mov     ah, 2Ch          ; get current time again
    int     21h              ; DH = current seconds (0..59)

    mov     al, prevSec      ; AL = previous seconds value
    cmp     dh, al           ; compare current seconds with previous
    je      check_key        ; if equal, same second ? skip updates

    ; We are in a new second now
    mov     prevSec, dh      ; update previous seconds to current

    ; ------------------------------------------------
    ; 2. Show next letter of the name at fixed position
    ; ------------------------------------------------
    call    ShowNextLetter

    ; ------------------------------------------------
    ; 3. Count seconds and minutes
    ; ------------------------------------------------
    inc     secCount          ; increase seconds counter
    cmp     secCount, 60      ; reached 60 seconds?
    jne     check_key         ; if not, continue with key check

    ; 60 seconds = 1 minute has passed
    mov     secCount, 0       ; reset seconds counter
    inc     minCount          ; increase minute counter
    call    ShowMinuteMessage ; show full name + minutes passed

check_key:
    ; ------------------------------------------------
    ; 4. Check keyboard for exit key Q/q
    ; ------------------------------------------------
    mov     ah, 01h          ; BIOS keyboard: check for key (no wait)
    int     16h
    jz      main_loop        ; ZF=1 ? no key pressed ? continue main loop

    ; Some key is pressed ? read it
    mov     ah, 00h
    int     16h              ; AL = ASCII code of key

    cmp     al, 'Q'          ; uppercase Q?
    je      quit
    cmp     al, 'q'          ; lowercase q?
    je      quit

    ; Any other key ? ignore and continue
    jmp     main_loop


; --------------------------------------------------
; PROCEDURE: ShowNextLetter
; Purpose:
;   Display the next character from nameStr in the
;   same screen position every second.
;
; Details:
;   - nameIdx holds the current index in nameStr.
;   - If we reach the '$' terminator, we restart from index 0.
; --------------------------------------------------
ShowNextLetter proc near

    ; Load current index into BL
    mov     bl, nameIdx
    mov     si, OFFSET nameStr     ; SI = address of nameStr
    mov     al, [si+bx]            ; AL = character at nameStr[nameIdx]

    ; Check for end of string ('$' marks the end)
    cmp     al, '$'
    jne     snl_not_end            ; if not '$', continue normally

    ; If we see '$', restart from the beginning of the name
    mov     bl, 0                  ; index = 0
    mov     nameIdx, bl
    mov     al, [si]               ; AL = first character of nameStr

snl_not_end:

    ; Set cursor position where the clock letter will be drawn
    ; Example position: row 10, column 35 (0-based)
    mov     ah, 02h                ; BIOS: set cursor position
    mov     bh, 0                  ; page number = 0
    mov     dh, 10                 ; row 10
    mov     dl, 35                 ; column 35
    int     10h

    ; Print the single character in AL
    mov     dl, al
    mov     ah, 02h                ; DOS: display character in DL
    int     21h

    ; Increase index for next second
    inc     bl
    mov     nameIdx, bl

    ret
ShowNextLetter endp


; --------------------------------------------------
; PROCEDURE: ShowMinuteMessage
; Purpose:
;   Called every time 60 seconds have passed.
;   Prints:
;       "AL AMIN HOSSAIN NAYEM X minute(s) passed"
;   where X is the number of minutes (0–9).
; --------------------------------------------------
ShowMinuteMessage proc near

    ; Convert minute count (0..9) to ASCII digit
    mov     al, minCount
    add     al, '0'               ; convert to ASCII
    mov     minStr, al            ; store as first char of minStr
                                  ; (second char is '$')

    ; Set cursor to where we want the message to appear
    ; Example: row 12, column 20
    mov     ah, 02h               ; BIOS: set cursor position
    mov     bh, 0                 ; page 0
    mov     dh, 12                ; row 12
    mov     dl, 20                ; column 20
    int     10h

    ; Print surname and full name text
    mov     ah, 09h               ; DOS: print string until '$'
    mov     dx, OFFSET surnameMsg
    int     21h

    ; Print the minutes number
    mov     ah, 09h
    mov     dx, OFFSET minStr
    int     21h

    ; Print the final text " minute(s) passed"
    mov     ah, 09h
    mov     dx, OFFSET minutesText
    int     21h

    ret
ShowMinuteMessage endp


; --------------------------------------------------
; DATA SECTION (in same segment as code, TINY model)
; --------------------------------------------------

; First name for text clock (letters shown one by one)
nameStr       db "AL AMIN$", 0

; Surname / full name for the minute message
surnameMsg    db "AL AMIN HOSSAIN NAYEM ", '$'

; One-character string for minutes, plus '$'
minStr        db "0", '$'

; Static text after minutes number
minutesText   db " minute(s) passed", '$'

; Time and index variables
prevSec       db 0       ; previously observed seconds (0..59)
secCount      db 0       ; seconds counter inside current minute
minCount      db 0       ; number of minutes passed
nameIdx       db 0       ; index in nameStr for text clock

; --------------------------------------------------
; Exit back to DOS
; --------------------------------------------------
quit:
    mov     ah, 4Ch       ; DOS: terminate program
    int     21h

end start
