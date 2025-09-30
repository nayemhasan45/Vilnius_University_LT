;--------------------------------------------------------------
; Count presses of H/h and Z/z separately
; Show totals only when E/e is pressed
; Model: TINY (COM file)
; Author: Al Amin Hossain Nayem
;--------------------------------------------------------------

org 100h

.data
    Hcount db 0                    ; Counter for H/h presses
    Zcount db 0                    ; Counter for Z/z presses
    prompt db 'Press H/h or Z/z (E/e to show results): $'
    finalH db 13,10,'Total H count = $'
    finalZ db 13,10,'Total Z count = $'
    name_msg db 13,10,'Program by: Al Amin Hossain Nayem$'

.code
start:
    mov ax, @data                  ; Initialize data segment
    mov ds, ax
    
    mov ah, 09h                    ; Display prompt
    mov dx, offset prompt
    int 21h

main_loop:
    mov ah, 7                      ; Read key without echo
    int 21h
    mov bl, al                     ; Store character in BL

    cmp bl, 'E'                    ; Check for exit condition (E)
    je show_results
    cmp bl, 'e'                    ; Check for exit condition (e)
    je show_results

    cmp bl, 'H'                    ; Check for H (uppercase)
    je inc_H
    cmp bl, 'h'                    ; Check for h (lowercase)
    je inc_H

    cmp bl, 'Z'                    ; Check for Z (uppercase)
    je inc_Z
    cmp bl, 'z'                    ; Check for z (lowercase)
    je inc_Z

    jmp main_loop                  ; Ignore other keys

inc_H:
    inc Hcount                     ; Increment H counter
    jmp main_loop                  ; Continue loop

inc_Z:
    inc Zcount                     ; Increment Z counter
    jmp main_loop                  ; Continue loop

;--- Display final results when E/e is pressed -----------------
show_results:
    mov ah, 09h                    ; Display H count message
    mov dx, offset finalH
    int 21h
    
    xor ax, ax                     ; Clear AX
    mov al, Hcount                 ; Load H count into AL
    call PrintDecimal              ; Display H count as decimal

    mov ah, 09h                    ; Display Z count message
    mov dx, offset finalZ
    int 21h
    
    xor ax, ax                     ; Clear AX
    mov al, Zcount                 ; Load Z count into AL
    call PrintDecimal              ; Display Z count as decimal
    
    mov ah, 09h                    ; Display name
    mov dx, offset name_msg
    int 21h

    mov ah, 4Ch                    ; Exit to DOS
    int 21h

;--- Decimal printing procedure for numbers 0-255 --------------
PrintDecimal:
    mov bx, 10                     ; Divisor = 10
    mov cx, 0                      ; Digit counter = 0
    
    cmp ax, 0                      ; Check if number is zero
    jne pd_make
    mov dl, '0'                    ; If zero, just print '0'
    mov ah, 02h
    int 21h
    ret

pd_make:
    xor dx, dx                     ; Clear DX for division
pd_loop:
    div bx                         ; AX = AX/10, DX = remainder
    push dx                        ; Save digit
    inc cx                         ; Count digits
    xor dx, dx                     ; Clear remainder
    test ax, ax                    ; Check if quotient is zero
    jne pd_loop                    ; If not, continue

pd_out:
    pop dx                         ; Get digit from stack
    add dl, '0'                    ; Convert to ASCII
    mov ah, 02h                    ; Display character
    int 21h
    loop pd_out                    ; Repeat for all digits
    ret

end start