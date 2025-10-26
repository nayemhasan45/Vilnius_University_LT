.model small
.stack 100h

.data
; Directory paths
dir1 db 'Al', 0
dir2 db 'Al\Amin', 0
dir3 db 'Al\Amin\Hossain', 0

; File paths
file1 db 'Al\info.txt', 0
file2 db 'Al\Amin\info.txt', 0
file3 db 'Al\Amin\Hossain\info.txt', 0

; Content to write
content db 'Al Amin Hossain Nayem', 13, 10
content_len equ $ - content

; Messages
msg_success db 'Success! All directories and files created.', 13, 10, '$'
msg_error db 'Error occurred!', 13, 10, '$'

fileHandle dw ?

.code
main PROC
    mov ax, @data
    mov ds, ax
    
    ; Create first directory
    lea dx, dir1
    mov ah, 39h
    int 21h
    
    ; Create second directory
    lea dx, dir2
    mov ah, 39h
    int 21h
    
    ; Create third directory
    lea dx, dir3
    mov ah, 39h
    int 21h
    
    ; Create and write file 1
    lea dx, file1
    call create_write_file
    
    ; Create and write file 2
    lea dx, file2
    call create_write_file
    
    ; Create and write file 3
    lea dx, file3
    call create_write_file
    
    ; Print success message
    lea dx, msg_success
    mov ah, 9
    int 21h
    
    ; Exit
    mov ax, 4C00h
    int 21h
main ENDP

create_write_file PROC
    ; Input: DS:DX = file path
    push ax
    push bx
    push cx
    
    mov si, dx              ; Save file path
    
    ; Create file (Function 3Ch)
    mov ah, 3Ch
    mov cx, 0
    int 21h
    
    jc create_error
    
    mov fileHandle, ax
    mov bx, ax
    
    ; Write to file (Function 40h)
    mov ah, 40h
    mov cx, content_len
    lea dx, content
    int 21h
    
    jc write_error
    
    ; Close file (Function 3Eh)
    mov ah, 3Eh
    mov bx, fileHandle
    int 21h
    
    jmp file_done
    
create_error:
write_error:
file_done:
    pop cx
    pop bx
    pop ax
    ret
create_write_file ENDP

end main