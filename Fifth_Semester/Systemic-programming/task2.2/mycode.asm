;==================================================================
; Program: Count 'x' and 'y' characters with repetition
; Format: MS-DOS .COM (org 100h)
; Author: Fixed and commented
; Description:
;   - Reads characters from the user (echoed to screen)
;   - Counts occurrences of 'x' and 'y' (case-insensitive)
;   - Stops reading input when 'q' or 'Q' is entered
;   - Asks for a repetition count (0-9)
;   - Prints the X and Y counts the specified number of times
;   - Uses DOS interrupt 21h for I/O
;==================================================================

.model tiny              ; Tiny memory model (code + data in one segment)
.code
org 100h                 ; COM programs start execution at 100h

start:
    ;-------------------------------------------
    ; Initialize counters
    ;-------------------------------------------
    xor cx, cx           ; CX = counter for 'x'
    xor bx, bx           ; BX = counter for 'y'

    ;-------------------------------------------
    ; Print initial prompt to the user
    ;-------------------------------------------
    mov ah, 09h          ; DOS function 09h = display string
    mov dx, offset prompt1
    int 21h              ; Call DOS to print the string

;==================================================================
; Main input loop
;==================================================================
input_loop:
    mov ah, 01h          ; DOS function 01h = read character with echo
    int 21h              ; AL = character entered

    ;-------------------------------------------
    ; Check if user wants to quit ('q' or 'Q')
    ;-------------------------------------------
    cmp al, 'q'
    je get_repetition_count
    cmp al, 'Q'
    je get_repetition_count

    ;-------------------------------------------
    ; Check for 'x' or 'X' and increment CX
    ;-------------------------------------------
    cmp al, 'x'
    je count_x
    cmp al, 'X'
    je count_x

    ;-------------------------------------------
    ; Check for 'y' or 'Y' and increment BX
    ;-------------------------------------------
    cmp al, 'y'
    je count_y
    cmp al, 'Y'
    je count_y

    ;-------------------------------------------
    ; Otherwise, ignore the character and continue
    ;-------------------------------------------
    jmp input_loop

;-------------------------------------------
; Increment 'x' counter
;-------------------------------------------
count_x:
    inc cx               ; CX = CX + 1
    jmp input_loop

;-------------------------------------------
; Increment 'y' counter
;-------------------------------------------
count_y:
    inc bx               ; BX = BX + 1
    jmp input_loop

;==================================================================
; Get repetition count from user
;==================================================================
get_repetition_count:
    ; Print newline
    mov ah, 09h
    mov dx, offset newline
    int 21h

    ; Print prompt for repetition count
    mov ah, 09h
    mov dx, offset prompt2
    int 21h

    ; Read one character (echoed)
    mov ah, 01h
    int 21h              ; AL = ASCII character '0'-'9'

    ; Convert ASCII to number (0-9)
    sub al, '0'          ; Convert ASCII to numeric
    xor ah, ah           ; Clear AH to avoid garbage in AX
    mov si, ax           ; SI = repetition count

    ; Print newline after reading repetition count
    mov ah, 09h
    mov dx, offset newline
    int 21h

;==================================================================
; Display results multiple times based on repetition count
;==================================================================
display_results:
    cmp si, 0
    je exit_program      ; If 0, exit immediately

    mov di, si           ; DI = loop counter

print_loop:
    ;-------------------------------------------
    ; Print X count message
    ;-------------------------------------------
    mov ah, 09h
    mov dx, offset msgX
    int 21h

    ; Print X count value (CX)
    mov ax, cx
    call print_number

    ; Print newline
    mov ah, 09h
    mov dx, offset newline
    int 21h

    ;-------------------------------------------
    ; Print Y count message
    ;-------------------------------------------
    mov ah, 09h
    mov dx, offset msgY
    int 21h

    ; Print Y count value (BX)
    mov ax, bx
    call print_number

    ; Print newline
    mov ah, 09h
    mov dx, offset newline
    int 21h

    ;-------------------------------------------
    ; Decrement repetition counter
    ;-------------------------------------------
    dec di
    jz exit_program       ; Exit if this was the last repetition

    ; Print separator (blank line) before next repetition
    mov ah, 09h
    mov dx, offset newline
    int 21h

    jmp print_loop

;==================================================================
; Exit program
;==================================================================
exit_program:
    mov ah, 4Ch          ; DOS function 4Ch = terminate program
    int 21h

;==================================================================
; SUBROUTINE: Print number in AX as decimal
;------------------------------------------------------------------
; Input: AX = number to print
; Uses: BX, CX, DX, SI (pushed and restored)
; Logic:
;   - If AX = 0, print '0'
;   - Otherwise, repeatedly divide by 10
;     and push remainders on the stack
;   - Then pop digits and print them
;==================================================================
print_number:
    push bx
    push cx
    push dx
    push si

    mov bx, 10           ; Divisor for decimal digits
    xor si, si           ; Digit counter = 0

    ;-------------------------------------------
    ; Special case: number = 0
    ;-------------------------------------------
    cmp ax, 0
    jne convert_digits

    mov dl, '0'          ; ASCII '0'
    mov ah, 02h
    int 21h
    jmp pn_done

;-------------------------------------------
; Convert number to digits
;-------------------------------------------
convert_digits:
    xor dx, dx           ; Clear DX before DIV
    div bx               ; AX = quotient, DX = remainder
    push dx              ; Save remainder (digit) on stack
    inc si               ; Increment digit counter
    test ax, ax
    jnz convert_digits   ; Continue if quotient != 0

;-------------------------------------------
; Print digits from stack
;-------------------------------------------
print_digits:
    pop dx               ; Get digit from stack
    add dl, '0'          ; Convert to ASCII
    mov ah, 02h
    int 21h
    dec si
    jnz print_digits     ; Loop until all digits printed

pn_done:
    pop si
    pop dx
    pop cx
    pop bx
    ret

;==================================================================
; Data section
;==================================================================
prompt1  db 'Enter characters (x/y to count, q to finish): $'
prompt2  db 'Enter repetition count (0-9): $'
msgX     db 'X count: $'
msgY     db 'Y count: $'
newline  db 0Dh, 0Ah, '$'

end start
