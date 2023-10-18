org 0x7C00
bits 16

section .text
    global _start

_start:
    mov ax, 0            ; Load segment address of program
    mov ds, ax           ; Set data segment to program segment

    mov ah, 0x0E         ; Set cursor function
    mov bh, 0x00         ; Display page 0
    int 0x10             ; Call video interrupt

    mov si, menu         ; Display menu
    call puts

get_choice:
    mov ah, 0            ; Get keyboard input
    int 0x16             ; Call BIOS interrupt

    cmp al, '1'          ; Compare input with '1'
    je load_program_1    ; Jump to load program 1 if equal

    cmp al, '2'          ; Compare input with '2'
    je load_program_2    ; Jump to load program 2 if equal

    jmp get_choice       ; Repeat if input is not '1' or '2'

load_program_1:
    jmp main             ; Jump to main.asm (placeholder)

load_program_2:
    jmp shell            ; Jump to shell.asm (AOS shell)

; Function to print a string
puts:
    pusha
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0x00
    int 0x10
    jmp .loop
.done:
    popa
    ret

section .data
    menu db 'Choose an option:', 0x0D, 0x0A
         db '1. Placeholder (main.asm)', 0x0D, 0x0A
         db '2. AOS Shell (shell.asm)', 0x0D, 0x0A
         db 'Enter your choice: ', 0

    times 510-($-$$) db 0
    dw 0xAA55
