; Name rotation program for emu8086
; Task:
;   Draw the name "AL AMIN" in graphics mode.
;   R key  -> rotate letters to the right side.
;   L key  -> rotate letters to the left side.
;   E key  -> exit back to text mode.
; Rotation is simulated with 3 different letter images:
;   frame 0 = left tilt, frame 1 = front, frame 2 = right tilt.

.model tiny
.code
org 100h

; -------------------------------------------------------
; CONSTANTS
; -------------------------------------------------------
NAME_START_X     EQU 80       ; starting X coordinate for the name
NAME_START_Y     EQU 80       ; starting Y coordinate for the name
LETTER_SPACING   EQU 10       ; distance between letters (pixels)
NUM_LETTERS      EQU 7        ; "A L _ A M I N" => 7 glyphs

; CURRENT_FRAME values:
; 0 = left-tilt, 1 = front, 2 = right-tilt
CURRENT_FRAME    db 1         ; initial view = front

LetterBaseX      dw 0         ; current letter base X
LetterBaseY      dw 0         ; current letter base Y

; Row-based shear amounts for rotation (per scanline)
; lower rows are shifted more -> gives 3D-like tilt effect
RowShift         db 0,0,1,1,2,2,3,3

; Flag: has graphics mode been initialized from PutPixel?
GraphicsInit     db 0

; -------------------------------------------------------
; GLYPH DATA (8x8 bitmaps for each letter)
; Each glyph = 8 bytes, each byte = 8 pixels (bit 7 = leftmost).
; -------------------------------------------------------

; Letter A
GlyphA db 00111100b  ; ..####..
       db 01000010b  ; .#....#.
       db 10000010b  ; #......#
       db 10000010b  ; #......#
       db 11111111b  ; ########
       db 10000010b  ; #......#
       db 10000010b  ; #......#
       db 00000000b  ; ........

; Letter L
GlyphL db 10000000b  ; #.......
       db 10000000b  ; #.......
       db 10000000b  ; #.......
       db 10000000b  ; #.......
       db 10000000b  ; #.......
       db 10000000b  ; #.......
       db 11111111b  ; ########
       db 00000000b  ; ........

; Space (blank, 8x8 all zeros)
GlyphSPACE db 00000000b
          db 00000000b
          db 00000000b
          db 00000000b
          db 00000000b
          db 00000000b
          db 00000000b
          db 00000000b

; Letter M
GlyphM db 10000001b  ; #......#
       db 11000011b  ; ##....##
       db 10100101b  ; #.#..#.#
       db 10100101b  ; #.#..#.#
       db 10011001b  ; #..##..#
       db 10000001b  ; #......#
       db 10000001b  ; #......#
       db 00000000b  ; ........

; Letter I
GlyphI db 11111111b  ; ########
       db 00011000b  ; ...##...
       db 00011000b  ; ...##...
       db 00011000b  ; ...##...
       db 00011000b  ; ...##...
       db 00011000b  ; ...##...
       db 11111111b  ; ########
       db 00000000b  ; ........

; Letter N
GlyphN db 10000001b  ; #......#
       db 11000001b  ; ##.....#
       db 10100001b  ; #.#....#
       db 10010001b  ; #..#...#
       db 10001001b  ; #...#..#
       db 10000101b  ; #....#.#
       db 10000011b  ; #.....##
       db 00000000b  ; ........

; Table of glyph pointers for "AL AMIN"
; Order: A, L, SPACE, A, M, I, N
LetterTable dw GlyphA
            dw GlyphL
            dw GlyphSPACE
            dw GlyphA
            dw GlyphM
            dw GlyphI
            dw GlyphN

; -------------------------------------------------------
; ENTRY POINT
; -------------------------------------------------------
start:
    ; DS = CS for .COM program
    mov ax, cs
    mov ds, ax

    ; ---- set graphics mode 13h (320x200x256) ----
    mov ah, 0
    mov al, 13h
    int 10h

    mov CURRENT_FRAME, 1   ; start with front view
    mov GraphicsInit, 1    ; graphics mode already set

    ; Draw the initial frame of the name
    call DrawName

MainLoop:
    ; Wait for key from BIOS keyboard (blocking)
    mov ah, 00h
    int 16h          ; AL = ASCII code

    cmp al, 'R'
    je  PressR
    cmp al, 'r'
    je  PressR

    cmp al, 'L'
    je  PressL
    cmp al, 'l'
    je  PressL

    cmp al, 'E'
    je  ExitProgram
    cmp al, 'e'
    je  ExitProgram

    jmp MainLoop     ; ignore any other keys

; --------------------------
; R key: rotate to the right
; --------------------------
PressR:
    mov al, CURRENT_FRAME
    cmp al, 2                ; frame 2 = max right
    jge PR_NoChange
    inc al
    mov CURRENT_FRAME, al
    call ClearScreen
    call DrawName
PR_NoChange:
    jmp MainLoop

; -------------------------
; L key: rotate to the left
; -------------------------
PressL:
    mov al, CURRENT_FRAME
    cmp al, 0                ; frame 0 = max left
    jle PL_NoChange
    dec al
    mov CURRENT_FRAME, al
    call ClearScreen
    call DrawName
PL_NoChange:
    jmp MainLoop

; -------------------------
; E key: back to text mode
; -------------------------
ExitProgram:
    mov ah, 0
    mov al, 03h              ; standard text mode 80x25
    int 10h
    mov ax, 4C00h
    int 21h

; -------------------------------------------------------
; ClearScreen: fill graphics screen with color 0 (black)
; using direct video memory at segment A000h.
; -------------------------------------------------------
ClearScreen proc near
    push ax
    push cx
    push di
    push es

    mov ax,0A000h            ; video memory segment
    mov es,ax
    xor di,di
    mov cx,320*200           ; 64,000 pixels
    xor al,al                ; color 0
cs_loop:
    stosb
    loop cs_loop

    pop es
    pop di
    pop cx
    pop ax
    ret
ClearScreen endp

; -------------------------------------------------------
; PutPixel: draw one pixel using INT 10h / AH=0Ch
; IN: CX=x, DX=y, AL=color
; Extra safety: if GraphicsInit=0, it sets graphics mode 13h.
; -------------------------------------------------------
PutPixel proc near
    push ax
    cmp GraphicsInit, 1
    je  pp_ready

    ; If somehow not in graphics mode, set it now
    mov ah, 0
    mov al, 13h
    int 10h
    mov GraphicsInit, 1

pp_ready:
    pop ax                  ; restore color in AL

    mov ah, 0Ch             ; write graphics pixel
    mov bh, 0               ; page 0
    int 10h
    ret
PutPixel endp

; -------------------------------------------------------
; DrawName: draws "AL AMIN" in current frame (0/1/2)
; It loops through LetterTable and calls DrawLetter.
; -------------------------------------------------------
DrawName proc near
    mov cx, NAME_START_X    ; current X for letter
    mov dx, NAME_START_Y    ; base Y for all letters

    mov bx, OFFSET LetterTable
    mov di, NUM_LETTERS

NextLetter:
    mov si, [bx]            ; SI = pointer to glyph

    mov [LetterBaseX], cx   ; store base position
    mov [LetterBaseY], dx

    call DrawLetter         ; draw one glyph

    add cx, LETTER_SPACING  ; move to next letter
    add bx, 2               ; next pointer in table
    dec di
    jnz NextLetter

    ret
DrawName endp

; -------------------------------------------------------
; DrawLetter: draw an 8x8 glyph with tilt based on CURRENT_FRAME.
; For each row:
;   - read one byte (8 bits) from glyph,
;   - for each set bit draw a pixel,
;   - X is shifted left/right by RowShift[row] depending on frame.
; -------------------------------------------------------
DrawLetter proc near
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov di, 0                   ; row index 0..7

RowLoop:
    cmp di, 8
    jge DoneRows

    ; AL = bitmap byte for this row
    mov bx, si
    add bx, di
    mov al, [bx]

    ; DL = row-based shift value (0..3)
    mov bx, OFFSET RowShift
    add bx, di
    mov dl, [bx]

    ; BH = CURRENT_FRAME (0/1/2)
    mov bh, CURRENT_FRAME

    mov ah, al                  ; AH = copy of row bits
    mov cl, 0                   ; column index 0..7

ColLoop:
    cmp cl, 8
    jge NextRow

    ; test highest bit of AH (bit 7)
    test ah, 10000000b
    jz SkipPixel

    ; X = baseX + column
    mov ax, [LetterBaseX]
    add ax, cx                  ; col offset

    ; apply tilt depending on CURRENT_FRAME
    cmp bh, 1
    je CoordFront               ; frame 1: no tilt

    cmp bh, 2
    je CoordRight               ; frame 2: tilt right

    ; frame 0 = left tilt
CoordLeft:
    mov bl, dl                  ; BL = shift
    xor bh, bh
    sub ax, bx                  ; X - shift
    jmp CoordDone

CoordRight:
    mov bl, dl
    xor bh, bh
    add ax, bx                  ; X + shift
    jmp CoordDone

CoordFront:
    ; X already = baseX + col (no change)

CoordDone:
    mov cx, ax                  ; CX = final X

    ; Y = baseY + row
    mov bx, [LetterBaseY]
    add bx, di
    mov dx, bx

    mov al, 15                  ; white color
    call PutPixel

SkipPixel:
    shl ah, 1                   ; shift next glyph bit into MSB
    inc cl
    jmp ColLoop

NextRow:
    inc di
    jmp RowLoop

DoneRows:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
DrawLetter endp

end start
