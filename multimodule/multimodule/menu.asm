; menu.asm
INCLUDE Irvine32.inc
INCLUDE declaration.inc

.386
.MODEL flat, stdcall
.STACK 4096

.DATA
menuTitle BYTE "MAIN MENU",0
option1   BYTE "1. Easy Level",0
option2   BYTE "2. Medium Level",0
option3   BYTE "3. Hard Level",0
option4   BYTE "4. Instructions",0
option5   BYTE "5. Exit",0
prompt    BYTE "Select an option (1-3): ",0
selection dword ?

.CODE
menu PROC exitFlag:byte

MenuStart:
    mov exitFlag,0
    mov eax, cyan + (black * 16)
    call SetTextColor
    call Clrscr
    mov ecx, 80
    mov dl, 0
    mov dh, 3
    call Gotoxy
    mov al, '='
    call DrawBorderLine
    mov dl, 35
    mov dh, 5
    call Gotoxy
    mov edx, OFFSET menuTitle
    call WriteString
    mov dl, 30
    mov dh, 7
    call Gotoxy
    mov edx, OFFSET option1
    call WriteString
    mov dl, 30
    mov dh, 8
    call Gotoxy
    mov edx, OFFSET option2
    call WriteString
    mov dl, 30
    mov dh, 9
    call Gotoxy
    mov edx, OFFSET option3
    call WriteString
    mov dl, 30
    mov dh, 10
    call Gotoxy
    mov edx, OFFSET option4
    call WriteString
    mov dl, 30
    mov dh, 11
    call Gotoxy
    mov edx, OFFSET option5
    call WriteString
    mov dl, 30
    mov dh, 13
    call Gotoxy
    mov edx, OFFSET prompt
    call WriteString
    mov ecx, 80
    mov dl, 0
    mov dh, 24
    call Gotoxy
    mov al, '='
    call DrawBorderLine
 GetInput:
    call ReadChar
    call WriteChar
    cmp al, '1'
    je EasySelected
    cmp al, '2'
    je MediumSelected
    cmp al, '3'
    je HardSelected
    cmp al, '4'
    je ShowInstructions
    cmp al, '5'
    je ExitProgram

    cmp al, '1'
    jb GetInput     
    cmp al, '5'
    ja GetInput

EasySelected:
    call level1
    
MediumSelected:
    call level2
    
HardSelected:
    call level3

ShowInstructions:
    call display_instructions
    jmp MenuStart

ExitProgram:
    call exitProcess
cmp selection,0
je calling

calling:
mov al,1
INVOKE menu,al

MenuEnd:
    mov eax, selection  
    ret
menu ENDP
END