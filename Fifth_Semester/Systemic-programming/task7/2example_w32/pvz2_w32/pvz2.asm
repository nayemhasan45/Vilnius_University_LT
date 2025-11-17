.486
.model flat, stdcall
option casemap:none

; ------------ Libraries ------------
includelib lib\kernel32.lib
includelib lib\user32.lib
includelib lib\gdi32.lib

; ------------ Includes -------------
include windows.inc
include kernel32.inc
include user32.inc
include gdi32.inc

; ------------ Prototypes -----------
WinMain   PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD
WndProc   PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD
PopupProc PROTO STDCALL :DWORD, :DWORD, :DWORD, :DWORD

; ===================================
.data?
hInstance  dd ?

; ===================================
.data
ClassName   db "FirstWindowClass",0
AppName     db "My First MASM32 Window",0

; Control window class names
EditClass   db "EDIT",0
ButtonClass db "BUTTON",0

BtnText     db "Show",0

; Control IDs
EDIT_MAIN_ID  equ 101
BTN_SHOW_ID   equ 102
EDIT_POP_ID   equ 201

; Handles
hMainEdit   dd ?
hMainButton dd ?
hPopupWnd   dd ?
hPopupEdit  dd ?

; Buffers
BUF_SIZE        equ 256
MainTextBuffer  db BUF_SIZE dup(?)
UserName        db " - From Al Amin",0

; Popup window class
PopupClassName  db "PopupWindowClass",0
PopupTitle      db "Popup Window",0


; ===================================
.code
start:
    invoke GetModuleHandle, NULL
    mov    hInstance, eax
    invoke WinMain, hInstance, NULL, NULL, SW_SHOWNORMAL
    invoke ExitProcess, NULL


; --------------------------------------------------------
; WinMain
; --------------------------------------------------------
WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWORD

    LOCAL wc :WNDCLASSEX
    LOCAL wc2:WNDCLASSEX
    LOCAL hwnd:DWORD
    LOCAL msg:MSG

    ; ---- main window class ----
    mov wc.cbSize, SIZEOF WNDCLASSEX
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, OFFSET WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0

    ; *** copy hInst into wc.hInstance (no mem?mem) ***
    push hInst
    pop  wc.hInstance

    mov wc.hbrBackground, COLOR_WINDOW+1
    mov wc.lpszMenuName, NULL
    mov wc.lpszClassName, OFFSET ClassName
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    mov wc.hIconSm, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax
    invoke RegisterClassEx, ADDR wc

    ; ---- popup window class ----
    mov wc2.cbSize, SIZEOF WNDCLASSEX
    mov wc2.style, CS_HREDRAW or CS_VREDRAW
    mov wc2.lpfnWndProc, OFFSET PopupProc
    mov wc2.cbClsExtra, 0
    mov wc2.cbWndExtra, 0

    ; *** copy hInst into wc2.hInstance (no mem?mem) ***
    push hInst
    pop  wc2.hInstance

    mov wc2.hbrBackground, COLOR_WINDOW+1
    mov wc2.lpszMenuName, NULL
    mov wc2.lpszClassName, OFFSET PopupClassName
    mov wc2.hCursor, NULL
    mov wc2.hIcon, NULL
    mov wc2.hIconSm, NULL
    invoke RegisterClassEx, ADDR wc2

    ; ---- create main window (standard resizable) ----
    invoke CreateWindowEx, 0, ADDR ClassName, ADDR AppName, \
           WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 450, 350, \
           NULL, NULL, hInst, NULL
    mov hwnd, eax

    invoke ShowWindow, hwnd, SW_SHOWNORMAL
    invoke UpdateWindow, hwnd

    ; ---- message loop ----
    .WHILE TRUE
        invoke GetMessage, ADDR msg, NULL, 0, 0
        .BREAK .IF (!eax)
        invoke TranslateMessage, ADDR msg
        invoke DispatchMessage, ADDR msg
    .ENDW

    mov eax, msg.wParam
    ret
WinMain endp


; --------------------------------------------------------
; WndProc – MAIN WINDOW
; --------------------------------------------------------
WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

    mov eax, uMsg

    ; ---------- WM_CREATE ----------
    .IF eax == WM_CREATE

        ; main edit control
        invoke CreateWindowEx, 0, ADDR EditClass, NULL, \
               WS_CHILD or WS_VISIBLE or WS_BORDER or ES_AUTOHSCROLL, \
               20, 20, 300, 25, hWnd, EDIT_MAIN_ID, hInstance, NULL
        mov hMainEdit, eax

        ; show button
        invoke CreateWindowEx, 0, ADDR ButtonClass, ADDR BtnText, \
               WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON, \
               20, 60, 100, 30, hWnd, BTN_SHOW_ID, hInstance, NULL
        mov hMainButton, eax

    ; ---------- WM_COMMAND ----------
    .ELSEIF eax == WM_COMMAND

        mov eax, wParam
        and eax, 0FFFFh
        cmp eax, BTN_SHOW_ID
        jne @F                     ; not our button

        ; read text from main edit
        invoke GetWindowText, hMainEdit, ADDR MainTextBuffer, BUF_SIZE

        ; append " - Al Amin"
        mov esi, OFFSET MainTextBuffer
find_zero:
            cmp BYTE PTR [esi], 0
            je  append_name
            inc esi
            jmp find_zero

append_name:
        mov edi, esi
        mov esi, OFFSET UserName
copy_loop:
            mov al, [esi]
            mov [edi], al
            inc edi
            inc esi
            cmp al, 0
            jne copy_loop

        ; create popup window
        invoke CreateWindowEx, 0, ADDR PopupClassName, ADDR PopupTitle, \
               WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 380, 180, \
               hWnd, NULL, hInstance, NULL
        mov hPopupWnd, eax
        invoke ShowWindow, hPopupWnd, SW_SHOWNORMAL
        invoke UpdateWindow, hPopupWnd

@@:

    ; ---------- WM_DESTROY ----------
    .ELSEIF eax == WM_DESTROY
        invoke PostQuitMessage, NULL

    ; ---------- default ----------
    .ELSE
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    .ENDIF

    ret
WndProc endp


; --------------------------------------------------------
; PopupProc – POPUP WINDOW
; --------------------------------------------------------
PopupProc PROC hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

    mov eax, uMsg

    .IF eax == WM_CREATE

        ; edit control inside popup
        invoke CreateWindowEx, 0, ADDR EditClass, NULL, \
               WS_CHILD or WS_VISIBLE or WS_BORDER or ES_AUTOHSCROLL, \
               20, 20, 300, 25, hWnd, EDIT_POP_ID, hInstance, NULL
        mov hPopupEdit, eax

        ; load text from main window
        invoke SetWindowText, hPopupEdit, ADDR MainTextBuffer

    .ELSEIF eax == WM_CLOSE

        ; read text back
        invoke GetWindowText, hPopupEdit, ADDR MainTextBuffer, BUF_SIZE

        ; write to main edit
        invoke SetWindowText, hMainEdit, ADDR MainTextBuffer

        invoke DestroyWindow, hWnd

    .ELSE
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .ENDIF

    xor eax, eax
    ret
PopupProc ENDP


end start
