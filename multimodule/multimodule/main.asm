INCLUDE Irvine32.inc
INCLUDE declaration.inc
.386
.MODEL flat, stdcall
.STACK 4096
ExitProcess PROTO, dwExitCode:DWORD

;=========STRUCTURES=============

STD_OUTPUT_HANDLE EQU -11
CONSOLE_CURSOR_INFO STRUCT
    dwSize DWORD ?
    bVisible DWORD ?
CONSOLE_CURSOR_INFO ENDS

words STRUCT
easy byte 7 DUP(?)
medium byte 9 DUP(?)
hard byte 17 DUP(?)
words ENDS

GAME_STATE STRUCT
    score DWORD 0
    current_level DWORD 1
    exitFlag BYTE 0
    bonus_active BYTE 0
GAME_STATE ENDS

LEVEL_SETTINGS STRUCT
    word_speed DWORD ?
    spawn_delay DWORD ?
LEVEL_SETTINGS ENDS

;=================MACROS===================
RefreshScreen MACRO
    push edx
    INVOKE score_display, game.score
    call ship_display
    call display_input
    pop edx
ENDM

HideCursor MACRO
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax
    
    mov cursorInfo.dwSize, 1
    mov cursorInfo.bVisible, FALSE
    
    INVOKE SetConsoleCursorInfo, hStdOut, ADDR cursorInfo
ENDM

SetColor MACRO color
    mov eax, color
    call SetTextColor
ENDM

MoveCursor MACRO row, col
    mov dh, row
    mov dl, col
    call Gotoxy
ENDM

DelayGame MACRO ms:=<30>
    mov eax, ms
    call Delay
ENDM

.DATA
    ; =======SPACE-SHIP=========
    ship1 byte "  00  ",0
    ship2 byte " 0000 ",0
    ship3 byte "000000",0
    ship4 byte "--------",0
    initial_col dword 40
    exitFlag byte 0
    ship5 byte "      ",0

    ; =========CURSOR-REMOVING===========
    consoleCursorInfo dword 0 
    bVisible BYTE 0 
    hStdOut HANDLE ?
    cursorInfo CONSOLE_CURSOR_INFO <>

    ;============WORDS============
 word_list words <"live", "flatter", "serendpty">,
              <"cat", "umbrella", "elephant">,
              <"blue", "guitar", "adventure">,
              <"jump", "window", "certainly">,
              <"idea", "planet", "beautiful">,
              <"fast", "summer", "important">
    word_count DWORD 6
    current_word BYTE 17 DUP(0) 
    word_length DWORD 0
    word_col DWORD ?
    word_row DWORD ?
    word_speed DWORD 2 
    word_timer DWORD 0
    word_active BYTE 0 
    last_word_time DWORD 0
    spawn_delay DWORD 20   
    game_tick DWORD 0
    word_hits BYTE 0   
    word_type BYTE 0 

    ; ============TYPING INPUT=================
    input_buffer BYTE 16 DUP(0)
    input_length DWORD 0
    input_prompt BYTE "Input: ",0
    clear_input BYTE "                ",0

    ; ==============BULLET WORD===============
    bullet_word BYTE 16 DUP(0)
    bullet_word_length DWORD 0
    bullet_row DWORD ?
    bullet_col DWORD ?
    bullet_active BYTE 0

    ; ============SOUND-PRODUCTION===============
    Beep PROTO,
    dwFreq:DWORD,     
    dwDuration:DWORD  
    sound_timer DWORD 0    
    sound_delay DWORD 20 

    ;===============BONUS================
    bonus_active byte 0

    ;==============GAME STATE===============
    game GAME_STATE <>

    ;============LEVELS===============
    level1S LEVEL_SETTINGS <15, 15>    
    level2S LEVEL_SETTINGS <12, 10>    
    level3S LEVEL_SETTINGS <10, 5>


.CODE
MAIN PROC
mov game.score, 0             
mov game.current_level, 1     
mov game.exitFlag, 0    
HideCursor
call Randomize
call welcome
call menu
MAIN ENDP


; =============LEVELS================
level1 PROC
    pusha
    call Clrscr
    SetColor cyan + (black * 16)
    HideCursor
    call ScreenDisplay
    call ship_display
    INVOKE score_display, game.score
    call display_input

    mov eax, level1S.word_speed
    mov word_speed, eax
    mov eax, level1S.spawn_delay
    mov spawn_delay, eax

    mov input_length, 0
    mov bullet_active, 0
    gameloop_level1:
        mov eax, sound_timer
        inc eax
        mov sound_timer, eax
        cmp eax, sound_delay
        jl skip_beep_level1
        
        mov sound_timer, 0
        mov al, 7             
        call WriteChar       
        
    skip_beep_level1:
         cmp game.exitFlag, 1
        je exit_level1
        call HandleInput
        call update_game_tick
        
        cmp word_active, 1
        jne skip_word_level1
        call move_word
    skip_word_level1:
        
        cmp bullet_active, 1
        jne skip_bullet_level1
        call move_bullet_word
        call check_bullet_collision
    skip_bullet_level1:
        
        cmp word_active, 0
        jne no_spawn_level1
        mov word_type,0
        call spawn_word
         
    no_spawn_level1:
        
        mov eax, 30 
        call Delay
        jmp gameloop_level1

    exit_level1:
        popa
        INVOKE  endgame,game.score
        ret
level1 ENDP

level2 PROC
    pusha
    call Clrscr
    SetColor cyan + (black * 16)
    HideCursor
    call ScreenDisplay
    call ship_display
    INVOKE score_display, game.score
    call display_input
    
    mov eax, level2S.word_speed
    mov word_speed, eax
    mov eax, level2S.spawn_delay
    mov spawn_delay, eax
    
    mov input_length, 0
    mov byte ptr [input_buffer], 0
    mov bullet_active, 0
    mov game.bonus_active, 0
    mov game_tick, 0
    mov last_word_time, 0

gameloop_level2:
   mov eax, sound_timer
        inc eax
        mov sound_timer, eax
        cmp eax, sound_delay
        jl skip_beep_level2
        
        mov sound_timer, 0
        mov al, 7             
        call WriteChar 
skip_beep_level2:

    cmp game.exitFlag, 1
    je exit_level2

    call HandleInput
    call update_game_tick

    cmp word_active, 1
    jne skip_word_level2
    call move_word
skip_word_level2:

    cmp bullet_active, 1
    jne skip_bullet_level2
    call move_bullet_word
    call check_bullet_collision
skip_bullet_level2:

    cmp word_active, 0
    jne no_spawn_level2
    mov word_type, 1           
    call spawn_word
no_spawn_level2:

    cmp game.score, 10
    jl skip_bonus_check
    cmp game.bonus_active, 1
    je skip_bonus_check
    
    mov game.bonus_active, 1
    INVOKE bonus, game.score
    
    call Clrscr
    SetColor cyan + (black * 16)
    call ScreenDisplay
    call ship_display
    INVOKE score_display, game.score
    call display_input
    
    cmp word_active, 1
    jne skip_redraw_word
    call draw_word
skip_redraw_word:
    
    cmp bullet_active, 1
    jne skip_redraw_bullet
    call draw_bullet_word
skip_redraw_bullet:

skip_bonus_check:
    mov eax, 30
    call Delay
    jmp gameloop_level2

exit_level2:
    popa
    INVOKE endgame, game.score
    ret
level2 ENDP

level3 PROC
    pusha
    call Clrscr
    SetColor cyan + (black * 16)
    HideCursor
    call ScreenDisplay
    call ship_display
    INVOKE score_display, game.score
    call display_input
    
    mov eax, level3S.word_speed
    mov word_speed, eax
    mov eax, level3S.spawn_delay
    mov spawn_delay, eax
    
    mov input_length, 0
    mov byte ptr [input_buffer], 0
    mov bullet_active, 0
    mov game.bonus_active, 0
    mov game_tick, 0
    mov last_word_time, 0

gameloop_level3:
    mov eax, sound_timer
        inc eax
        mov sound_timer, eax
        cmp eax, sound_delay
        jl skip_beep_level3
        
        mov sound_timer, 0
        mov al, 7             
        call WriteChar 
skip_beep_level3:

    cmp game.exitFlag, 1
    je exit_level3

    call HandleInput
    call update_game_tick

    cmp word_active, 1
    jne skip_word_level3
    call move_word
skip_word_level3:

    cmp bullet_active, 1
    jne skip_bullet_level3
    call move_bullet_word
    call check_bullet_collision
skip_bullet_level3:

    cmp word_active, 0
    jne no_spawn_level3
    call maybe_spawn_word_level3
no_spawn_level3:

    cmp game.score, 10
    jl skip_bonus_check
    cmp bonus_active, 1
    je skip_bonus_check
    
    mov bonus_active, 1
    INVOKE bonus, game.score
    
    call Clrscr
    SetColor cyan + (black * 16)
    call ScreenDisplay
    call ship_display
    INVOKE score_display, game.score
    call display_input
    
    cmp word_active, 1
    jne skip_redraw_word
    call draw_word
skip_redraw_word:
    
    cmp bullet_active, 1
    jne skip_redraw_bullet
    call draw_bullet_word
skip_redraw_bullet:

skip_bonus_check:
    mov eax, 30
    call Delay
    jmp gameloop_level3

exit_level3:
    popa
    INVOKE endgame, game.score
    ret
level3 ENDP


; ===================WORDS==================
update_game_tick PROC
    inc game_tick
    ret
update_game_tick ENDP


maybe_spawn_word_level3 PROC
    cmp word_active, 1
    je dont_spawn_level3
    
    mov eax, game_tick
    sub eax, last_word_time
    cmp eax, spawn_delay
    jl dont_spawn_level3
    
    mov word_type, 2
    
    call spawn_word
    mov eax, game_tick
    mov last_word_time, eax
    
dont_spawn_level3:
    ret
maybe_spawn_word_level3 ENDP

spawn_word PROC
    mov eax, word_count
    call RandomRange
    mov ebx, SIZEOF words 
    mul ebx
    mov esi, OFFSET word_list
    add esi, eax  

    mov edi, OFFSET current_word
    mov ecx, 0

    cmp word_type, 0 
    je copy_easy
    cmp word_type, 1 
    je copy_medium
    cmp word_type, 2 
    je copy_hard

copy_easy:
    mov ecx, LENGTHOF word_list.easy
    jmp copy_word

copy_medium:
    add esi, 7 
    mov ecx, LENGTHOF word_list.medium
    jmp copy_word

copy_hard:
    add esi, 16 
    mov ecx, LENGTHOF word_list.hard
    jmp copy_word

copy_word:
    cld
    rep movsb

    mov esi, OFFSET current_word
    mov ecx, 0
count_length:
    cmp BYTE PTR [esi + ecx], 0
    je length_done
    inc ecx
    jmp count_length
length_done:
    mov word_length, ecx

    mov eax, 80
    sub eax, word_length
    call RandomRange
    inc eax
    mov word_col, eax

    mov word_row, 1
    mov word_active, 1

    mov word_hits, 0
    call draw_word
    mov eax, game_tick
    mov last_word_time, eax
    ret
spawn_word ENDP


draw_word PROC
    push edx
    push eax
    
    cmp word_type, 1
    je draw_long_word
    
    SetColor brown + (black * 16)
    
    mov dh, byte ptr word_row
    mov dl, byte ptr word_col
    call Gotoxy
    mov edx, offset current_word
    call WriteString
    jmp draw_done
    
draw_long_word:
    SetColor lightRed + (black * 16)
    
    mov dh, byte ptr word_row
    mov dl, byte ptr word_col
    call Gotoxy
    mov edx, offset current_word
    call WriteString
    
draw_done:
    pop eax
    pop edx
    ret
draw_word ENDP

clear_word PROC
    push edx
    push eax
    push ecx
    
    SetColor cyan + (black * 16)
    
    mov dh, byte ptr word_row
    mov dl, byte ptr word_col
    call Gotoxy
    mov ecx, word_length
    mov al, ' '
clear_loop:
    call WriteChar
    loop clear_loop
    
    pop ecx
    pop eax
    pop edx
    ret
clear_word ENDP

move_word PROC
    cmp word_active, 1
    jne done_move
    
    mov eax, game_tick
    xor edx, edx
    div word_speed
    cmp edx, 0
    jne done_move
    
    call clear_word
    
    inc word_row
    
    cmp word_row, 21
    jl draw_new_pos
    
word_reached_bottom:
    mov word_active, 0
    INVOKE endgame,game.score
    jmp done_move
    
draw_new_pos:
    call draw_word
    
done_move:
    ret
move_word ENDP

; ======================BULLET WORD==================
draw_bullet_word PROC
    push edx
    push eax
    
    SetColor yellow + (black * 16)
    
    mov dh, byte ptr bullet_row
    mov dl, byte ptr bullet_col
    call Gotoxy
    mov edx, offset bullet_word
    call WriteString
    
    pop eax
    pop edx
    ret
draw_bullet_word ENDP

clear_bullet_word PROC
    push edx
    push eax
    push ecx
    
    SetColor cyan + (black * 16)
    
    mov dh, byte ptr bullet_row
    mov dl, byte ptr bullet_col
    call Gotoxy
    mov ecx, bullet_word_length
    mov al, ' '
clear_bullet_loop:
    call WriteChar
    loop clear_bullet_loop
    
    pop ecx
    pop eax
    pop edx
    ret
clear_bullet_word ENDP

move_bullet_word PROC
    cmp bullet_active, 1
    jne done_bullet_move
    
    call clear_bullet_word
    
    dec bullet_row
    
    cmp bullet_row, 0
    jle deactivate_bullet
    
    call draw_bullet_word
    jmp done_bullet_move
    
deactivate_bullet:
    mov bullet_active, 0
    
done_bullet_move:
    ret
move_bullet_word ENDP

check_bullet_collision PROC
    cmp bullet_active, 1
    jne no_collision
    cmp word_active, 1
    jne no_collision
    
    mov eax, bullet_row
    cmp eax, word_row
    jne no_collision
    
    mov eax, bullet_col
    add eax, bullet_word_length
    dec eax
    cmp eax, word_col
    jl no_collision
    
    mov eax, word_col
    add eax, word_length
    dec eax
    cmp eax, bullet_col
    jl no_collision
    
    push esi
    push edi
    push ecx
    
    mov esi, offset current_word
    mov edi, offset bullet_word
    mov ecx, word_length
    cld
    repe cmpsb
    jne no_match
    
    call clear_word
    call clear_bullet_word
    mov word_active, 0
    mov bullet_active, 0
    add game.score, 2
    INVOKE score_display, game.score
    RefreshScreen
    jmp collision_done
    
no_match:
    call clear_bullet_word
    mov bullet_active, 0
    
collision_done:
    pop ecx
    pop edi
    pop esi
    
no_collision:
    ret
check_bullet_collision ENDP

; =====================SHIP-DISPLAY====================
ship_display PROC
    SetColor cyan + (black * 16)
    mov dh, 21
    mov dl, byte PTR initial_col
    call Gotoxy
    mov edx, offset ship1
    call WriteString
    
    mov dh, 22
    mov dl, byte PTR initial_col
    call Gotoxy
    mov edx, offset ship2
    call WriteString
    
    mov dh, 23
    mov dl, byte PTR initial_col
    call Gotoxy
    mov edx, offset ship3
    call WriteString
    
    mov dh, 24
    mov dl, byte PTR initial_col
    call Gotoxy
    mov edx, offset ship4
    call WriteString
    
    ret
ship_display ENDP

removing_ship PROC
    pusha
    SetColor cyan + (black * 16)
    mov dh, 21
    mov dl, byte PTR initial_col
    call Gotoxy
    mov edx, offset ship5
    call WriteString
    
    mov dh, 22
    mov dl, byte PTR initial_col
    call Gotoxy
    mov edx, offset ship5
    call WriteString
    
    mov dh, 23
    mov dl, byte PTR initial_col
    call Gotoxy
    mov edx, offset ship5
    call WriteString
    
    mov dh, 24
    mov dl, byte PTR initial_col
    call Gotoxy
    mov edx, offset ship4
    call WriteString
    
    popa
    ret
removing_ship ENDP

; ========================CURSOR-HIDING======================
HideCursor PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax
    
    mov cursorInfo.dwSize, 1
    mov cursorInfo.bVisible, FALSE
    
    INVOKE SetConsoleCursorInfo, hStdOut, ADDR cursorInfo
    ret
HideCursor ENDP

; ====================INPUT HANDLING=============
HandleInput PROC
    call ReadKey
    jz no_input
    cmp al, 1Bh
    je exit_program
    cmp al, 0
    je handle_arrow
    cmp al, 8
    je handle_backspace
    cmp al, 13
    je shoot_word
    cmp input_length, 15
    jge no_input
    mov ebx, input_length
    mov input_buffer[ebx], al
    inc input_length
    call display_input
    jmp no_input
handle_backspace:
    cmp input_length, 0
    je no_input
    dec input_length
    mov ebx, input_length
    mov input_buffer[ebx], 0
    call display_input
    jmp no_input
handle_arrow:
    cmp ah, 4Bh
    je move_left
    cmp ah, 4Dh
    je move_right
    jmp no_input
    
shoot_word:
    INVOKE Beep, 1000,100
    cmp input_length, 0
    je no_input
    cmp bullet_active, 1
    je no_input
    
    mov esi, OFFSET input_buffer
    mov edi, OFFSET bullet_word
    mov ecx, input_length
    inc ecx
    cld
    rep movsb
    
    mov eax, input_length
    mov bullet_word_length, eax
    
    mov eax, initial_col
    add eax, 2
    mov bullet_col, eax
    mov bullet_row, 20
    mov bullet_active, 1
    
    mov edi, OFFSET input_buffer
    mov ecx, 16
    mov al, 0
    rep stosb
    mov input_length, 0
    
    call display_input
    call draw_bullet_word
    jmp no_input
    
move_left:
    call removing_ship
    sub initial_col, 4
    cmp initial_col, 1
    jle set_min_col
    call ship_display
    jmp no_input
    
move_right:
    call removing_ship
    add initial_col, 4
    cmp initial_col, 86
    jge set_max_col
    call ship_display
    jmp no_input
    
set_min_col:
    mov initial_col, 1
    call ship_display
    jmp no_input
    
set_max_col:
    mov initial_col, 86
    call ship_display
    jmp no_input
    
exit_program:
    mov game.exitFlag, 1
    
no_input:
    ret
HandleInput ENDP

display_input PROC
    push edx
    SetColor white + (black * 16)
    MoveCursor 19, 1
    mov edx, offset clear_input
    call WriteString
    MoveCursor 19, 1
    mov edx, offset input_prompt
    call WriteString
    mov edx, offset input_buffer
    call WriteString
    pop edx
    ret
display_input ENDP
END MAIN
