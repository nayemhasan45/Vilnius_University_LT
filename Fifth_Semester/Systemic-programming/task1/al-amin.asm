.model tiny
.code
org 100h

start:
    mov ax,@data
    mov ds,ax

;---- 1) SURNAME + NAME twice on line 2 column 1 ----
    mov ah,02h        ; set cursor
    mov bh,0
    mov dh,1          ; line 2 (0-based)
    mov dl,0          ; column 1
    int 10h
    mov ah,09h
    mov dx,offset text1
    int 21h

    mov ah,02h
    mov dh,2          ; line 3
    mov dl,0
    int 10h
    mov ah,09h
    mov dx,offset text1
    int 21h

;---- 2) NAME three times upward, column 10 ----
    ; line 12
    mov ah,02h
    mov dh,11
    mov dl,9
    int 10h
    mov ah,09h
    mov dx,offset text2
    int 21h

    ; line 11
    mov ah,02h
    mov dh,10
    mov dl,9
    int 10h
    mov ah,09h
    mov dx,offset text2
    int 21h

    ; line 10
    mov ah,02h
    mov dh,9
    mov dl,9
    int 10h
    mov ah,09h
    mov dx,offset text2
    int 21h

;---- 3) SURNAME once on line 17 column 13 ----
    mov ah,02h
    mov dh,16
    mov dl,12
    int 10h
    mov ah,09h
    mov dx,offset text3
    int 21h

    ret

;----------------- Single data block -----------------------
.data
text1 db 'AL AMIN HOSSAIN NAYEM',0Dh,0Ah,'$'
text2 db 'NAYEM',0Dh,0Ah,'$'
text3 db 'AL AMIN HOSSAIN',0Dh,0Ah,'$'

end start
