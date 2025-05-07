INCLUDE Irvine32.inc
INCLUDE declaration.inc

.386
.MODEL flat, stdcall
.STACK 4096

.DATA
starics byte "-",0

.CODE

ScreenDisplay PROC
    local row :dword
    local column :dword
    mov eax, cyan + (black * 16)
    call SetTextColor
    mov row, 0
    mov column, 0
    mov ecx, 25
l1:
    push ecx
    mov ecx, 93
    mov column, 0
l2:
        cmp row, 0
        je display
        cmp row, 24
        je display
        cmp column, 0
        je display
        cmp column, 92
        je display
skip:
        mov al, ' '
        call WriteChar
        inc column
        jmp looping
display:
        mov edx, offset starics
        call WriteString
        inc column
looping:
        loop l2
    inc row
    pop ecx
    call Crlf
    loop l1
    ret
ScreenDisplay ENDP
END