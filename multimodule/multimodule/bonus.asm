INCLUDE Irvine32.inc
INCLUDE declaration.inc

.386
.MODEL flat, stdcall
.STACK 4096

.data
    string1 byte "THE BONUS HAS BEEN ACTIVATED", 0
    string2 byte "REST YOUR HANDS FOR 5 SECONDS",0
    delayTime dword 5000 

.code
bonus PROC score:dword
    pushad     
    mov eax,10
    div score
    cmp edx,0
    jne terminate

    call Clrscr
    call DrawBorderLine
    call ScreenDisplay
    call ship_display

     mov eax, lightMagenta + (black * 16)
    call SetTextColor

    mov dh, 15          
    mov dl, 5
    call Gotoxy
    mov edx, OFFSET string1
    call WriteString

    mov dh, 15          
    mov dl, 6
    call Gotoxy
    mov edx, OFFSET string2
    call WriteString

    mov eax, delayTime
    call Delay

    call Clrscr
    mov dh, 0           
    mov dl, 0
    call Gotoxy

terminate:
    popad
    ret
bonus ENDP
END