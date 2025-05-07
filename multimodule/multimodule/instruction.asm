INCLUDE Irvine32.inc
INCLUDE declaration.inc

.386
.MODEL flat, stdcall
.STACK 4096

.DATA

instrTitle1 BYTE " _____________                                                                               ",0
instrTitle2 BYTE " |____   ____|                                                                               ",0
instrTitle3 BYTE "      | |     __    __   ____  ________ _____  __   __   ____  ________ __   ____   __    __ ",0
instrTitle4 BYTE "      | |     |\    ||  //   \ |||||||| ||  \\ ||   ||  //  \\ |||||||| ||  //  \\  |\    || ",0
instrTitle5 BYTE "      | |     ||\   ||  \\        ||    ||//   ||   || ||         ||    || ||    || ||\   || ",0
instrTitle6 BYTE "      | |     || \  ||   \\\      ||    ||\\   ||   || ||         ||    || ||    || || \  || ",0
instrTitle7 BYTE "  ____| |___  ||  \ || \    ||    ||    || \\  ||   || ||         ||    || ||    || ||  \ || ",0
instrTitle8 BYTE "  ||  ||   || ||   \||  \\||||    ||    ||  \\ |||||||  ||||||    ||    ||  \\||//  ||   \|| ",0
    
instrText1 BYTE "Game Controls:",0
instrText2 BYTE "- Left/Right Arrow Keys: Move your spaceship",0
instrText3 BYTE "- Type the falling word and press Enter: Shoot word",0
instrText4 BYTE "- ESC: Exit game or return to menu",0
instrText5 BYTE " ",0
instrText6 BYTE "Game Objective:",0
instrText7 BYTE "- Shoot typed words to match falling words and earn points",0
instrText8 BYTE "- Avoid letting words reach the bottom",0
instrText9 BYTE "- Higher difficulty levels have faster words",0
instrBackMsg BYTE "Press any key to return to menu...",0

.CODE
display_instructions PROC
call Clrscr
    mov eax, cyan + (black * 16)
    call SetTextColor
    
    mov dl, 10
    mov dh, 2
    call Gotoxy
    mov edx, OFFSET instrTitle1
    call WriteString
    
    mov dl, 10
    mov dh, 3
    call Gotoxy
    mov edx, OFFSET instrTitle2
    call WriteString
    
    mov dl, 10
    mov dh, 4
    call Gotoxy
    mov edx, OFFSET instrTitle3
    call WriteString
    
    mov dl, 10
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET instrTitle4
    call WriteString
    
    mov dl, 10
    mov dh, 6
    call Gotoxy
    mov edx, OFFSET instrTitle5
    call WriteString

    mov dl, 10
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET instrTitle6
    call WriteString

    mov dl, 10
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET instrTitle7
    call WriteString

    mov dl, 10
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET instrTitle8
    call WriteString
    
    mov dl, 20
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET instrText1
    call WriteString
    
    mov dl, 22
    mov dh, 12
    call Gotoxy
    mov edx, OFFSET instrText2
    call WriteString
    
    mov dl, 22
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET instrText3
    call WriteString
    
    mov dl, 22
    mov dh, 14
    call Gotoxy
    mov edx, OFFSET instrText4
    call WriteString
    
    mov dl, 20
    mov dh, 15
    call Gotoxy
    mov edx, OFFSET instrText6
    call WriteString
    
    mov dl, 22
    mov dh, 16
    call Gotoxy
    mov edx, OFFSET instrText7
    call WriteString
    
    mov dl, 22
    mov dh, 17
    call Gotoxy
    mov edx, OFFSET instrText8
    call WriteString
    
    mov dl, 22
    mov dh, 18
    call Gotoxy
    mov edx, OFFSET instrText9
    call WriteString
    
    mov dl, 20
    mov dh, 20
    call Gotoxy
    mov edx, OFFSET instrBackMsg
    call WriteString
    
    mov ecx, 80
    mov dl, 0
    mov dh, 1
    call Gotoxy
    mov al, '='
    call DrawBorderLine
    
    mov dh, 22
    call Gotoxy
    mov al, '='
    call DrawBorderLine
    
    call ReadChar
    ret
display_instructions ENDP

END
