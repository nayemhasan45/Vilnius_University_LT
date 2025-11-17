INCLUDE Irvine32.inc

.data
    nameStr     BYTE "AL AMIN",0
    surnameStr  BYTE "HOSSAIN",0

    promptN     BYTE "Enter NOMB (how many times to print): ",0
    promptW     BYTE "Enter one word: ",0

    NOMB        DWORD ?
    MAXLEN      = 40
    wordBuf     BYTE MAXLEN+1 DUP(0)

.code
main PROC

    call Clrscr

    ;===========================================
    ; PART 1: Check first character
    ;===========================================

    call ReadChar        ; AL = typed character
    call IsDigit         ; ZF = 1 if AL is digit 0..9
    jz  printName        ; if digit -> print name

printSurname:
    mov edx, OFFSET surnameStr
    call WriteString
    call Crlf
    jmp afterPrint

printName:
    mov edx, OFFSET nameStr
    call WriteString
    call Crlf

afterPrint:

    ;===========================================
    ; PART 2: Read NOMB
    ;===========================================

    mov edx, OFFSET promptN
    call WriteString
    call ReadInt          ; EAX = integer
    mov NOMB, eax

    ;===========================================
    ; PART 3: Read one word
    ;===========================================

    mov edx, OFFSET promptW
    call WriteString

    mov edx, OFFSET wordBuf
    mov ecx, MAXLEN
    call ReadString       ; stores null-terminated string

    ;===========================================
    ; PART 4: Print word NOMB times
    ; start from row 10, same column 5
    ;===========================================

    mov ecx, NOMB         ; loop counter
    mov dh, 10            ; row start
    mov dl, 5             ; column position

printLoop:
    call Gotoxy           ; move cursor
    mov edx, OFFSET wordBuf
    call WriteString
    inc dh                ; next row
    loop printLoop

    exit                  ; exit to Windows
main ENDP

END main
