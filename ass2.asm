%macro io 4
    ; Macro to simplify syscall usage for input/output
    ; %1: Syscall number (rax)
    ; %2: File descriptor (rdi) - 0 for stdin, 1 for stdout
    ; %3: Address of the buffer (rsi)
    ; %4: Length of the buffer (rdx)
    mov rax, %1          ; Set syscall number in rax
    mov rdi, %2          ; Set file descriptor in rdi
    mov rsi, %3          ; Set pointer to the buffer in rsi
    mov rdx, %4          ; Set length of the buffer in rdx
    syscall              ; Perform the syscall
%endmacro

section .data
    ; Static data section for storing messages and constants
    msg1 db "Write 64 ALP to accept a string from user and display the length.", 10, "Name: sagar", 10, "Roll no: 7248", "Date: 10/02/25", 10
    msg1len equ $-msg1   ; Length of msg1
    msg2 db "Enter string: ", 10
    msg2len equ $-msg2   ; Length of msg2
    msg3 db "The length of string is: ", 10
    msg3len equ $-msg3   ; Length of msg3
    newline db 10        ; Newline character

section .bss
    ; Uninitialized data section for buffers and variables
    string resb 20       ; Buffer for input string (up to 20 bytes)
    len resb 1           ; Variable to store the length of the string
    lens resb 2          ; Buffer for storing ASCII representation of length

section .data
global _start            ; Entry point for the program

_start:
    ; Print the initial message (msg1)
    io 1, 1, msg1, msg1len

    ; Prompt the user to enter a string (msg2)
    io 1, 1, msg2, msg2len

    ; Read the user input into the string buffer
    io 0, 0, string, 20  ; Read up to 20 bytes from stdin into the buffer

    ; Calculate the length of the string
    dec rax              ; Decrement rax (rax contains the number of bytes read)
    mov [len], rax       ; Store the length in the `len` variable

    ; Print the message for displaying the length (msg3)
    io 1, 1, msg3, msg3len

    ; Convert the length value to a 2-character ASCII string
    mov bl, [len]        ; Load the length value into bl
    call hex_ascii64     ; Call the function to convert the length to ASCII

    ; Exit the program
    mov rax, 60          ; Syscall number for exit
    mov rdi, 0           ; Exit status (0 for success)
    syscall              ; Perform the exit syscall

hex_ascii64:
    ; Function to convert a number in BL to a 2-character ASCII hexadecimal string
    mov rsi, lens        ; Load the address of the lens buffer into rsi
    mov rcx, 2           ; Convert 2 hexadecimal digits (length is a single byte)

next2:
    ; Process each 4-bit nibble of the number
    rol bl, 4            ; Rotate BL left by 4 bits to extract the next nibble
    mov al, bl           ; Get the lowest 4 bits of BL
    and al, 0fh          ; Mask to isolate the nibble
    cmp al, 9            ; Check if the nibble is 0-9
    jbe add30h           ; If yes, jump to add30h
    add al, 7H           ; Adjust for 'A'-'F'

add30h:
    ; Convert the nibble to its ASCII character
    add al, 30H          ; Convert numeric value to ASCII character
    mov [rsi], al        ; Store the character in the lens buffer
    inc rsi              ; Move to the next position in the buffer
    loop next2           ; Repeat for all nibbles

    ; Print the converted ASCII string and a newline
    io 1, 1, lens, 2     ; Write the 2-character ASCII string to stdout
    io 1, 1, newline, 1  ; Write a newline to stdout
    ret                  ; Return to the caller
