INCLUDE Irvine32.inc
INCLUDE declaration.inc

.386
.MODEL flat, stdcall
.STACK 4096

.DATA
    score1 BYTE "  ___  ___  ___  ___   ___ ",0
    score2 BYTE " /    /    |   |/   \ |    ",0
    score3 BYTE " \__  |    |   ||   | |_   ",0
    score4 BYTE " ___) |    |   || |\\ |    ",0
    score5 BYTE "|____ \___ |___|| | \\|___ ",0
    score6 byte "Score: ",0

.CODE
; SCORE-DISPLAY
score_display PROC score:dword
    push eax
    push edx
    push ebx
    
    mov dh, 2
    mov dl, 94
    call Gotoxy
    mov edx, OFFSET score1
    call WriteString
    
    mov dh, 3
    mov dl, 94
    call Gotoxy
    mov edx, OFFSET score2
    call WriteString
    
    mov dh, 4
    mov dl, 94
    call Gotoxy
    mov edx, OFFSET score3
    call WriteString
    
    mov dh, 5
    mov dl, 94
    call Gotoxy
    mov edx, OFFSET score4
    call WriteString
    
    mov dh, 6
    mov dl, 94
    call Gotoxy
    mov edx, OFFSET score5
    call WriteString
    
    mov dh, 9
    mov dl, 94
    call Gotoxy
    mov edx, OFFSET score6
    call WriteString
    
    mov eax, score
    call WriteInt
    
    pop ebx
    pop edx
    pop eax
    ret
score_display ENDP
END


