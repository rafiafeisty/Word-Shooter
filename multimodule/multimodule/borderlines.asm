INCLUDE Irvine32.inc
INCLUDE declaration.inc

.386
.MODEL flat, stdcall
.STACK 4096

.DATA

.CODE
DrawBorderLine PROC
    push ecx
    push eax
    mov ecx, 80
DrawLoop:
    call WriteChar
    loop DrawLoop
    pop eax
    pop ecx
    ret
DrawBorderLine ENDP
END

