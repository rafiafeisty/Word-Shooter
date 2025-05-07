INCLUDE Irvine32.inc
INCLUDE declaration.inc

.386
.MODEL flat, stdcall
.STACK 4096

.DATA
welcomeTitle2 BYTE "   _____                   _____                      ",0
welcomeTitle3 BYTE "  |_   _|                 |  ___|                     ",0
welcomeTitle4 BYTE "    | | _ __   ___ _ __   | |_ _ __ _ __ _   _        ",0
welcomeTitle5 BYTE "    | || '_ \ / _ \ '_ \  |  _| '__| '__| | | |       ",0
welcomeTitle6 BYTE "   _| || | | |  __/ | | | | | | |  | |  | |_| |       ",0
welcomeTitle7 BYTE "   \___/_| |_|\___|_| |_| \_| |_|  |_|   \__, |       ",0
welcomeTitle8 BYTE "                                          __/ |       ",0
welcomeTitle9 BYTE "                                         |___/        ",0
pressKeyMsg   BYTE "         Press any key to begin your journey...",0
controlsMsg1  BYTE "Controls: Left/Right Arrow = Move | ESC = Exit",0
controlsMsg2  BYTE "          Type word + Enter = Shoot Word",0
versionMsg    BYTE "TYPER v1.0",0

.CODE


welcome PROC
    mov eax, cyan + (black * 16)
    call SetTextColor
    
    call Clrscr

    mov ecx, 80
    mov dl, 0
    mov dh, 3
    call Gotoxy
    mov al, '='
    call DrawBorderLine

    mov dl, 20
    mov dh, 5
    call Gotoxy
    mov edx,OFFSET welcomeTitle2
    call WriteString

    mov dl, 20
    mov dh, 6
    call Gotoxy
    mov edx,OFFSET welcomeTitle3
    call WriteString

    mov dl, 20
    mov dh, 7
    call Gotoxy
    mov edx,OFFSET welcomeTitle4
    call WriteString

    mov dl, 20
    mov dh, 8
    call Gotoxy
    mov edx,OFFSET welcomeTitle5
    call WriteString

    mov dl, 20
    mov dh, 9
    call Gotoxy
    mov edx,OFFSET welcomeTitle6
    call WriteString

    mov dl, 20
    mov dh, 10
    call Gotoxy
    mov edx,OFFSET welcomeTitle7
    call WriteString

    mov dl, 20
    mov dh, 11
    call Gotoxy
    mov edx,OFFSET welcomeTitle8
    call WriteString

    mov dl, 20
    mov dh, 12
    call Gotoxy
    mov edx,OFFSET welcomeTitle9
    call WriteString

    mov dl, 20
    mov dh, 13
    call Gotoxy
    mov edx,OFFSET pressKeyMsg 
    call WriteString

    mov dl, 20
    mov dh, 14
    call Gotoxy
    mov edx,OFFSET controlsMsg1 
    call WriteString

    mov dl, 20
    mov dh, 15
    call Gotoxy
    mov edx,OFFSET controlsMsg1 
    call WriteString

    mov dl, 20
    mov dh, 16
    call Gotoxy
    mov edx,OFFSET versionMsg
    call WriteString
     
    mov ecx, 80
    mov dl, 0
    mov dh, 24
    call Gotoxy
    mov al, '='
    call DrawBorderLine

    call Readkey
    WaitForSpace:
    call ReadChar     
    cmp al, ' '     
    jne WaitForSpace

    
    ret
welcome ENDP
END