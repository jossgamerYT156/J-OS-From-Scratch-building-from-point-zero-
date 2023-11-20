#!/bin/bash

show_menu() {
    echo "Menu:"
    echo "1. Build Files"
    echo "2. Clear Remnant Files"
    echo "3. Run VM"
    echo "4. Quit"
}

build_files() {
    # Assemble the bootloader, main, and shell files
    nasm -f bin -o bootloader.bin bootloader.asm
    nasm -f bin -o main.bin main.asm
    nasm -f bin -o shell.bin shell.asm

    # Combine the files into one
    cat bootloader.bin main.bin shell.bin > combined.bin

    echo "Files built successfully."
}

clear_files() {
    rm bootloader.bin main.bin shell.bin combined.bin
    echo "Remnant files cleared."
}

run_vm() {
    qemu-system-i386 -drive format=raw,file=combined.bin
}

while true; do
    show_menu

    read -p "Enter your choice (1-4): " choice
    case $choice in
        1) build_files ;;
        2) clear_files ;;
        3) run_vm ;;
        4) exit ;;
        *) echo "Invalid choice. Please enter a number between 1 and 4." ;;
    esac

    echo
done
