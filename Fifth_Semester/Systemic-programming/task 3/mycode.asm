;=================================================================
; PROGRAM TITLE : 2D CHAIR DRAWING IN GRAPHICS MODE (FINAL CLEAN)
; AUTHOR        : Al Amin Hossain Nayem
; ENVIRONMENT   : EMU8086 / MS-DOS 16-bit
; DESCRIPTION   :
;   This program draws a clean 2D chair using BIOS INT 10h.
;   It includes:
;       - Seat (top with perspective edges)
;       - two legs
;       - One horizontal connector bar
;       - Backrest with two vertical bars
;   Uses only INT 10h (graphics) and INT 21h (keyboard & exit)
;=================================================================

.model small
.stack 100h

.data
msg db 13,10,'Press any key to exit...$'   ; message to display before exit

.code
main proc
    mov ax, @data
    mov ds, ax              ; Initialize data segment register (DS)

    mov ax, 0013h           ; AH=00h, AL=13h ? Set 320x200, 256-color mode
    int 10h                 ; BIOS video interrupt

    mov al, 14              ; Set drawing color to yellow 

    ; FRONT EDGE of the seat (x = 100 ? 180, y = 130)
    mov cx,100              ; Start X position
    mov dx,130              ; Y coordinate fixed for horizontal line
seat_front:
    mov ah,0Ch              ; AH=0Ch ? Write pixel to screen
    mov bh,0                ; Video page 0
    int 10h                 ; Call BIOS to plot the pixel
    inc cx                  ; Move right (increase X)
    cmp cx,180              ; Continue until reaching X = 180
    jbe seat_front          ; Jump back if not reached end

    ; BACK EDGE of the seat (x = 120 ? 200, y = 115)
    mov cx,120              ; Start X position for back edge
    mov dx,115              ; Slightly higher Y (to create perspective)
seat_back:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc cx                  ; Move right
    cmp cx,200
    jbe seat_back

    ; LEFT DIAGONAL connecting front and back edge (100,130 ? 120,115)
    mov cx,100              ; Start bottom-left of seat
    mov dx,130
seat_left:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc cx                  ; Move right
    dec dx                  ; Move up (for diagonal)
    cmp cx,120              ; Continue until X reaches 120
    jbe seat_left

    ; RIGHT DIAGONAL connecting front and back edge (180,130 ? 200,115)
    mov cx,180              ; Start bottom-right of seat
    mov dx,130
seat_right:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc cx                  ; Move right
    dec dx                  ; Move up
    cmp cx,200              ; Stop when reaching X = 200
    jbe seat_right



    ; FRONT LEFT LEG (x = 110, y = 130 ? 180)
    mov cx,110              ; X coordinate fixed for left leg
    mov dx,130              ; Start Y position
front_left:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc dx                  ; Move pixel downward
    cmp dx,180              ; Stop when reaching bottom
    jbe front_left

    ; FRONT RIGHT LEG (x = 170, y = 130 ? 180)
    mov cx,170
    mov dx,130
front_right:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc dx                  ; Move downward
    cmp dx,180
    jbe front_right

    mov cx,110              ; Start X at left leg
    mov dx,165              ; Y coordinate for connector bar
connector:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc cx                  ; Move right
    cmp cx,170              ; Stop when reaching right leg
    jbe connector

    ; LEFT VERTICAL FRAME (x = 115, y = 70 ? 115)
    mov cx,115              ; Fixed X for left side of backrest
    mov dx,70               ; Start Y (top)
back_left:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc dx                  ; Move downward
    cmp dx,115              ; Stop when reaching bottom
    jbe back_left

    ; RIGHT VERTICAL FRAME (x = 195, y = 70 ? 115)
    mov cx,195              ; X for right side
    mov dx,70
back_right_v:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc dx
    cmp dx,115
    jbe back_right_v

    ; TOP HORIZONTAL FRAME (x = 115 ? 195, y = 70)
    mov cx,115              ; Start from left side
    mov dx,70               ; Y fixed (top bar)
back_top:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc cx                  ; Move right
    cmp cx,195              ; Stop when reaching right end
    jbe back_top

    ; INNER BAR 1 (x = 140, y = 70 ? 115)
    mov cx,140              ; X for first inner vertical bar
    mov dx,70
inner1:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc dx                  ; Draw down
    cmp dx,115
    jbe inner1

    ; INNER BAR 2 (x = 160, y = 70 ? 115)
    mov cx,160              ; X for second inner vertical bar
    mov dx,70
inner2:
    mov ah,0Ch
    mov bh,0
    int 10h
    inc dx                  ; Move downward
    cmp dx,115
    jbe inner2

    mov ah,07h              ; AH=07h ? Wait for key press (no echo)
    int 21h                 ; MS-DOS interrupt to pause

    mov ax,0003h            ; Set mode 03h ? 80x25 text mode
    int 10h                 ; Switch back to text screen

    mov ax,4C00h            ; Terminate program (AH=4Ch)
    int 21h                 ; MS-DOS interrupt to exit
main endp

END main
