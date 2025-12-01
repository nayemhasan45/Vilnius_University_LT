; -------------------------------------------------------
; BKeyCounter.asm
; 
; Task:
;  - Count how many times the B key was pressed.
;  - Keyboard recording continues until the E key is pressed.
;  - After that, read a number N from the keyboard.
;  - Print your name N times on the screen.
;
; Build as a 32-bit console application with Irvine32.lib.
; -------------------------------------------------------

INCLUDE Irvine32.inc        ; Irvine32 library (32-bit, console) 

.data
; ----- Messages -----
msgIntro    BYTE "Press keys on the keyboard.",0Dh,0Ah
            BYTE "I will count how many times you press 'B'.",0Dh,0Ah
            BYTE "Recording stops when you press 'E'.",0Dh,0Ah,0Dh,0Ah,0
msgPrompt   BYTE "Start pressing keys (B, E or anything).",0Dh,0Ah,0
msgDone     BYTE 0Dh,0Ah,"You pressed 'B' ",0
msgTimes    BYTE " times.",0Dh,0Ah,0Dh,0Ah,0
msgEnterN   BYTE "Now enter a number (how many times to print your name): ",0
msgNameLine BYTE "ali hamza",0Dh,0Ah,0

; ----- Variables -----
bCount      DWORD 0       ; how many times B was pressed
N           DWORD 0       ; how many times to print the name

.code
main PROC

    ; ----- Introduction text -----
    mov  edx, OFFSET msgIntro
    call WriteString

    mov  edx, OFFSET msgPrompt
    call WriteString

; ================================
; PART 1: Count B presses until E
; ================================
ReadKeysLoop:
    ; Wait for a single character from keyboard
    call ReadChar          ; AL = character

    ; Check for 'E' or 'e'  -> finish recording
    cmp  al, 'E'
    je   EndKeyRecording
    cmp  al, 'e'
    je   EndKeyRecording

    ; Check for 'B' or 'b'  -> increase counter
    cmp  al, 'B'
    je   IncBCount
    cmp  al, 'b'
    je   IncBCount

    jmp  ReadKeysLoop      ; other keys are ignored

IncBCount:
    inc  bCount
    jmp  ReadKeysLoop

EndKeyRecording:

    ; Show how many times B was pressed
    mov  edx, OFFSET msgDone
    call WriteString

    mov  eax, bCount       ; number to display
    call WriteDec          ; show count

    mov  edx, OFFSET msgTimes
    call WriteString

; ==========================================
; PART 2: Read N and print your name N times
; ==========================================

    mov  edx, OFFSET msgEnterN
    call WriteString

    ; Read integer from keyboard (user types digits, presses Enter)
    call ReadInt           ; EAX = integer
    mov  N, eax

    call Crlf

    ; Print your name N times
    mov  ecx, N            ; loop counter
PrintNameLoop:
    cmp  ecx, 0
    jle  DonePrinting

    mov  edx, OFFSET msgNameLine
    call WriteString

    dec  ecx
    jmp  PrintNameLoop

DonePrinting:

    call WaitMsg      ; wait for key press before closing
    exit              ; clean exit
main ENDP
END main

