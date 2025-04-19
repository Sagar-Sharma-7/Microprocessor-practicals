section .data
    name_roll db "Sagar, Roll No: 7248", 10
    name_roll_len equ $ - name_roll
    msg1 db "Enter first 8-bit hex number (2 digits): ", 10
    msg1len equ $ - msg1
    msg2 db "Enter second 8-bit hex number (2 digits): ", 10
    msg2len equ $ - msg2
    msg3 db "Result (Successive Addition): ", 10
    msg3len equ $ - msg3
    msg4 db "Result (Shift and Add): ", 10
    msg4len equ $ - msg4
    dispbuff db 4 dup(0)       ; Buffer for displaying 4-digit hex result
    newline db 10              ; Newline character

section .bss
    ascii_num resb 3           ; Buffer for 2-digit hex input + newline
    num1 resb 1                ; First hex number
    num2 resb 1                ; Second hex number

; Macro to print messages using sys_write
%macro PRINT 2
    mov rax, 1          ; System call number for sys_write
    mov rdi, 1          ; File descriptor (1 = stdout)
    mov rsi, %1         ; Buffer address
    mov rdx, %2         ; Length of buffer
    syscall             ; Make system call
%endmacro

; Macro to accept input using sys_read
%macro ACCEPT 2
    mov rax, 0          ; System call number for sys_read
    mov rdi, 0          ; File descriptor (0 = stdin)
    mov rsi, %1         ; Buffer address
    mov rdx, %2         ; Length of buffer
    syscall             ; Make system call
%endmacro

section .text
    global _start
_start:
    ; Display name and roll number
    PRINT name_roll, name_roll_len

    ; Display message for first number
    PRINT msg1, msg1len
    ; Accept first number
    ACCEPT ascii_num, 3        ; 2 digits + newline
    call Ascii_to_Hex          ; Convert to hex
    mov [num1], bl             ; Store first number

    ; Display message for second number
    PRINT msg2, msg2len
    ; Accept second number
    ACCEPT ascii_num, 3        ; 2 digits + newline
    call Ascii_to_Hex          ; Convert to hex
    mov [num2], bl             ; Store second number

    ; Perform multiplication using Successive Addition
    call Succ_Add
    PRINT msg3, msg3len        ; Display result header
    PRINT dispbuff, 4          ; Display result
    PRINT newline, 1           ; Newline for formatting

    ; Perform multiplication using Shift and Add
    call Shift_Add
    PRINT msg4, msg4len        ; Display result header
    PRINT dispbuff, 4          ; Display result
    PRINT newline, 1           ; Newline for formatting

    ; Exit program
    mov rax, 60                ; sys_exit
    mov rdi, 0                 ; Return code 0
    syscall

; (Remaining functions unchanged)
