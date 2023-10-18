org 0x7C00
bits 16

%define ENDL 0x0D, 0x0A

section .data
    ; Add a flag to determine if the shell is active
    shell_active db 0

start:
    jmp main

enable_cursor:
    ; Enable blinking cursor
    mov ah, 1
    mov ch, 0x06 ; Starting line
    mov cl, 0x07 ; Ending line
    int 0x10
    ret

clear_screen:
    mov ah, 0x06
    mov al, 0
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    ret

puts:
    push si
    push ax
    push bx

.loop:
    lodsb
    or al, al
    jz .done

    mov ah, 0x0E
    mov bh, 0
    int 0x10

    jmp .loop

.done:
    pop bx
    pop ax
    pop si
    ret

wait_for_key:
    mov ah, 0
    int 0x16
    ret

scroll_up:
    ; Scroll up slowly at 2 lines per second
    mov ah, 6     ; Scroll up function
    mov al, 1     ; Number of lines to scroll
    mov bh, 7     ; Text attribute
    mov cx, 0     ; Top left corner of the scrolling region
    mov dx, 0x184F ; Bottom right corner of the scrolling region
    int 0x10
    ret

draw_loading_bar:
    ; Draw a loading bar made of ASCII dots
    mov si, loading_bar
    call puts
    ret

get_input:
    xor di, di        ; Clear input buffer
.read_char:
    mov ah, 0x00
    int 0x16          ; BIOS interrupt for keyboard input
    cmp al, 0x0D     ; Check if Enter key is pressed
    je .end_input
    stosb            ; Store character in buffer
    mov ah, 0x0E
    int 0x10          ; Display character
    jmp .read_char
.end_input:
    mov al, 0        ; Null-terminate the string
    stosb
    ret

shell:
    ; Set the shell active flag
    mov byte [shell_active], 1

    ; Display prompt
    mov si, prompt
    call puts

    ; Get user input
    mov di, input_buffer
    call get_input

    ; Display user input
    mov si, input_buffer
    call puts

    ; Reset the shell active flag
    mov byte [shell_active], 0

    ; Return to caller
    ret

main:
    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7C00

    call clear_screen

    ; Enable blinking cursor
    call enable_cursor

    ; Display the startup message after a key press
    mov si, startup_text
    input_buffer: times 128 db 0
    call puts

    ; Wait for a key press
    call wait_for_key

    ; Clear the screen
    call clear_screen

    ; Display welcome message
    mov si, welcome_text
    call puts

    ; Slowly scroll up the welcome message
    mov cx, 1   ; Number of times to scroll (adjust as needed)
scroll_loop:
    call scroll_up
    loop scroll_loop

    ; Draw loading bar
    call draw_loading_bar

    ; Check if shell_active flag is set
    mov al, [shell_active]
    cmp al, 1
    je .suspend_main

    ; Continue with your main code here...
    jmp .continue_main

.suspend_main:
    ; Suspend the main code until shell exits
    jmp .suspend_main

.continue_main:
    ; Continue main code here...
    jmp .continue_main

.halt:
    jmp .halt

welcome_text db 'Welcome to ArcadeOS!', ENDL
             db 'Press any key to continue...', ENDL
             db 0

loading_bar db '..........', 0

startup_text db 'Welcome to ArcadeOS!', ENDL
             db 'Type help to see the help message' ENDL
             db 'Press any key to continue...', ENDL
             db 0

prompt db 'AOS>> ', 0

times 510-($-$$) db 0
dw 0xAA55
