.model small
.stack 100h
.data

filename        db 'your_name.txt', 0
newfilename     db 'renamed.txt', 0

menu_text       db 0Dh, 0Ah, '=== FILE OPERATIONS MENU ===', 0Dh, 0Ah
                db '1 - Create file (your_name.txt)', 0Dh, 0Ah
                db '2 - Edit file (add name and surname)', 0Dh, 0Ah
                db '3 - Clean file content', 0Dh, 0Ah
                db '4 - Rename file', 0Dh, 0Ah
                db '5 - Change file date', 0Dh, 0Ah
                db '6 - Print directory file list', 0Dh, 0Ah
                db '7 - Print file content', 0Dh, 0Ah
                db '0 - Exit', 0Dh, 0Ah
                db 'Choose option: $'

msg_created     db 0Dh, 0Ah, 'File created successfully!', 0Dh, 0Ah, '$'
msg_edited      db 0Dh, 0Ah, 'File edited successfully!', 0Dh, 0Ah, '$'
msg_cleaned     db 0Dh, 0Ah, 'File cleaned successfully!', 0Dh, 0Ah, '$'
msg_renamed     db 0Dh, 0Ah, 'File renamed successfully!', 0Dh, 0Ah, '$'
msg_datechange  db 0Dh, 0Ah, 'File date changed successfully!', 0Dh, 0Ah, '$'
msg_error       db 0Dh, 0Ah, 'Error occurred!', 0Dh, 0Ah, '$'
msg_content     db 0Dh, 0Ah, '=== FILE CONTENT ===', 0Dh, 0Ah, '$'
msg_dirlist     db 0Dh, 0Ah, '=== DIRECTORY LISTING ===', 0Dh, 0Ah, '$'
msg_entername   db 0Dh, 0Ah, 'Enter your name and surname: $'
msg_enterdate   db 0Dh, 0Ah, 'Enter new date (DD/MM/YYYY): $'
newline         db 0Dh, 0Ah, '$'

kbd_buffer      db 100, 0, 100 dup('$')
input_buffer    db 100 dup(0)
file_handle     dw 0
dta_buffer      db 43 dup(0)
search_mask     db '*.*', 0

day             db 0
month           db 0
year            dw 0

.code
main proc
    mov ax, @data
    mov ds, ax

menu_loop:
    mov ah, 09h
    mov dx, offset menu_text
    int 21h
    
    mov ah, 01h
    int 21h

    cmp al, '0'
    je exit_program
    cmp al, '1'
    je do_create
    cmp al, '2'
    je do_edit
    cmp al, '3'
    je do_clean
    cmp al, '4'
    je do_rename
    cmp al, '5'
    je do_date
    cmp al, '6'
    je do_list
    cmp al, '7'
    je do_print
    jmp menu_loop

do_create:  
    call create_file
    jmp menu_loop
do_edit:    
    call edit_file
    jmp menu_loop
do_clean:   
    call clean_file
    jmp menu_loop
do_rename:  
    call rename_file
    jmp menu_loop
do_date:    
    call change_date
    jmp menu_loop
do_list:    
    call list_directory
    jmp menu_loop
do_print:   
    call print_file
    jmp menu_loop

exit_program:
    mov ah, 4Ch
    mov al, 0
    int 21h

; ==============================
; PROCEDURES
; ==============================

create_file proc
    ; Delete file if exists (ignore errors)
    mov ah, 41h
    mov dx, offset filename
    int 21h

    ; Create new file
    mov ah, 3Ch
    mov cx, 0
    mov dx, offset filename
    int 21h
    jc create_error

    mov file_handle, ax

    ; Close file
    mov ah, 3Eh
    mov bx, file_handle
    int 21h

    mov ah, 09h
    mov dx, offset msg_created
    int 21h
    ret

create_error:
    mov ah, 09h
    mov dx, offset msg_error
    int 21h
    ret
create_file endp


edit_file proc
    ; Prompt for name
    mov ah, 09h
    mov dx, offset msg_entername
    int 21h

    ; Get input
    mov ah, 0Ah
    mov dx, offset kbd_buffer
    int 21h

    ; Open file for read/write
    mov ah, 3Dh
    mov al, 2
    mov dx, offset filename
    int 21h
    jc edit_error
    mov file_handle, ax

    ; Move to end of file
    mov ah, 42h
    mov al, 2
    mov bx, file_handle
    xor cx, cx
    xor dx, dx
    int 21h

    ; Write the input text
    mov ah, 40h
    mov bx, file_handle
    xor ch, ch
    mov cl, [kbd_buffer+1]
    mov dx, offset kbd_buffer+2
    int 21h

    ; Add newline
    mov ah, 40h
    mov bx, file_handle
    mov cx, 2
    mov dx, offset newline
    int 21h

    ; Close file
    mov ah, 3Eh
    mov bx, file_handle
    int 21h

    mov ah, 09h
    mov dx, offset msg_edited
    int 21h
    ret

edit_error:
    mov ah, 09h
    mov dx, offset msg_error
    int 21h
    ret
edit_file endp


clean_file proc
    ; Delete the file
    mov ah, 41h
    mov dx, offset filename
    int 21h

    ; Create empty file
    mov ah, 3Ch
    mov cx, 0
    mov dx, offset filename
    int 21h
    jc clean_error

    mov bx, ax
    mov ah, 3Eh
    int 21h

    mov ah, 09h
    mov dx, offset msg_cleaned
    int 21h
    ret

clean_error:
    mov ah, 09h
    mov dx, offset msg_error
    int 21h
    ret
clean_file endp


rename_file proc
    mov ah, 56h
    mov dx, offset filename
    mov di, offset newfilename
    int 21h
    jc rename_error

    mov ah, 09h
    mov dx, offset msg_renamed
    int 21h
    ret

rename_error:
    mov ah, 09h
    mov dx, offset msg_error
    int 21h
    ret
rename_file endp


change_date proc
    ; Get date from user
    mov ah, 09h
    mov dx, offset msg_enterdate
    int 21h

    ; Read day (DD)
    call read_two_digits
    mov day, al
    
    ; Read slash
    mov ah, 01h
    int 21h
    
    ; Read month (MM)
    call read_two_digits
    mov month, al
    
    ; Read slash
    mov ah, 01h
    int 21h
    
    ; Read year (YYYY)
    call read_four_digits
    mov year, ax

    ; Open file
    mov ah, 3Dh
    mov al, 2
    mov dx, offset filename
    int 21h
    jc date_error
    mov file_handle, ax

    ; Set file date
    mov ah, 57h
    mov al, 1
    mov bx, file_handle
    mov cx, year
    mov dh, month
    mov dl, day
    int 21h
    jc date_error

    ; Close file
    mov ah, 3Eh
    mov bx, file_handle
    int 21h

    mov ah, 09h
    mov dx, offset msg_datechange
    int 21h
    ret

date_error:
    mov ah, 09h
    mov dx, offset msg_error
    int 21h
    ret
change_date endp

; Helper procedure to read two digits
read_two_digits proc
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
    mov ah, 01h
    int 21h
    sub al, '0'
    mov ah, 10
    mul ah
    add al, bl
    ret
read_two_digits endp

; Helper procedure to read four digits (year)
read_four_digits proc
    ; Read first two digits (century)
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
    
    ; Calculate century part: (bh*10 + bl)*100
    mov al, bh
    mov cl, 10
    mul cl
    add al, bl
    mov cl, 100
    mul cl
    mov dx, ax
    
    ; Read last two digits (year)
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bh, al
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
    
    ; Calculate year part: bh*10 + bl
    mov al, bh
    mov cl, 10
    mul cl
    add al, bl
    
    ; Total year = dx + ax
    add ax, dx
    
    ; Convert to DOS date format (year since 1980)
    sub ax, 1980
    ret
read_four_digits endp


list_directory proc
    mov ah, 09h
    mov dx, offset msg_dirlist
    int 21h

    ; Set DTA
    mov ah, 1Ah
    mov dx, offset dta_buffer
    int 21h

    ; Find first file
    mov ah, 4Eh
    mov cx, 0
    mov dx, offset search_mask
    int 21h
    jc list_done

list_next:
    ; Print filename
    mov si, offset dta_buffer + 30
print_fname:
    mov al, [si]
    cmp al, 0
    je fname_done
    mov dl, al
    mov ah, 02h
    int 21h
    inc si
    jmp print_fname

fname_done:
    mov ah, 09h
    mov dx, offset newline
    int 21h

    ; Find next file
    mov ah, 4Fh
    int 21h
    jnc list_next

list_done:
    ret
list_directory endp


print_file proc
    mov ah, 09h
    mov dx, offset msg_content
    int 21h

    ; Open file
    mov ah, 3Dh
    mov al, 0
    mov dx, offset filename
    int 21h
    jc print_error
    mov file_handle, ax

read_loop:
    ; Read one character
    mov ah, 3Fh
    mov bx, file_handle
    mov cx, 1
    mov dx, offset input_buffer
    int 21h
    cmp ax, 0
    je read_done

    ; Print character
    mov ah, 02h
    mov dl, [input_buffer]
    int 21h
    jmp read_loop

read_done:
    ; Close file
    mov ah, 3Eh
    mov bx, file_handle
    int 21h

    mov ah, 09h
    mov dx, offset newline
    int 21h
    ret

print_error:
    mov ah, 09h
    mov dx, offset msg_error
    int 21h
    ret
print_file endp

main endp
end main