section .text
    global shell

; Function to print a string
puts:
    pusha
    mov ah, 0x0E
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    popa
    ret

; Function to get user input
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
    ; Get user input
    mov di, input_buffer
    call get_input

    ; Display user input
    mov si, input_buffer
    call puts

    ; Return to caller
    ret

section .data
    input_buffer db 128 dup(0)
