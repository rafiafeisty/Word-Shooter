INCLUDE Irvine32.inc
INCLUDE declaration.inc

.386
.MODEL flat, stdcall
.STACK 4096

.DATA
    gameOverTitle1 BYTE "   _____          __  __ ______    ______      ________ _____   ",0
    gameOverTitle2 BYTE "  / ____|   /\   |  \/  |  ____|  / __ \ \    / /  ____|  __ \  ",0
    gameOverTitle3 BYTE " | |  __   /  \  | \  / | |__    | |  | \ \  / /| |__  | |)  |  ",0
    gameOverTitle4 BYTE " | | |_ | / /\ \ | |\/| |  __|   | |  | |\ \/ / |  __| |  _  /  ",0
    gameOverTitle5 BYTE " | |__| |/ ____ \| |  | | |____  | |__| | \  /  | |____| | \ \  ",0
    gameOverTitle6 BYTE "  \_____/_/    \_\_|  |_|______|  \____/   \/   |______|_|  \_\ ",0
    finalScoreMsg  BYTE "                   Your Final Score: ",0
    restartMsg     BYTE "             Press any key to play again...",0
    exitMsg        BYTE "                 ESC to return to menu",0

.CODE
endgame PROC, score:DWORD
    ; Set color and clear screen
    mov eax, red + (black * 16)
    call SetTextColor
    call Clrscr

    ; Display game over title
    mov dl, 20
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET gameOverTitle1
    call WriteString

    mov dl, 20
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET gameOverTitle2
    call WriteString

    mov dl, 20
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET gameOverTitle3
    call WriteString

    mov dl, 20
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET gameOverTitle4
    call WriteString

    mov dl, 20
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET gameOverTitle5
    call WriteString

    mov dl, 20
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET gameOverTitle6
    call WriteString

    mov eax, white + (black * 16)
    call SetTextColor

    mov dl, 35
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET finalScoreMsg
    call WriteString
    mov eax, score       
    call WriteDec

    mov dl, 30
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET restartMsg
    call WriteString

    mov dl, 30
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET exitMsg
    call WriteString

    call ReadChar
    
    cmp al, 27          
    je ExitGame
    
    jmp ReturnToMain

ExitGame:
    call ExitProcess
    ret

ReturnToMain:
    call main
    ret
endgame ENDP
END