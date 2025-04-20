section .data
    name_roll db "Sagar, Roll No: 7248", 10    ; Display name and roll number
    name_roll_len equ $ - name_roll            ; Length of name_roll string
    msg1 db "Enter first 8-bit hex number (2 digits): ", 10
    msg1len equ $ - msg1                       ; Length of msg1 string
    msg2 db "Enter second 8-bit hex number (2 digits): ", 10
    msg2len equ $ - msg2                       ; Length of msg2 string
    msg3 db "Result (Successive Addition): ", 10
    msg3len equ $ - msg3                       ; Length of msg3 string
    msg4 db "Result (Shift and Add): ", 10
    msg4len equ $ - msg4                       ; Length of msg4 string
    dispbuff db 4 dup(0)                       ; Buffer for displaying 4-digit hex result
    newline db 10                              ; Newline character for formatting

section .bss
    ascii_num resb 3                           ; Buffer for 2-digit hex input + newline
    num1 resb 1                                ; First hex number
    num2 resb 1                                ; Second hex number

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

    ; Prompt for and read first hex number
    PRINT msg1, msg1len
    ACCEPT ascii_num, 3                        ; Read 2 digits + newline
    call Ascii_to_Hex                          ; Convert ASCII to hex
    mov [num1], bl                             ; Store the result in num1

    ; Prompt for and read second hex number
    PRINT msg2, msg2len
    ACCEPT ascii_num, 3                        ; Read 2 digits + newline
    call Ascii_to_Hex                          ; Convert ASCII to hex
    mov [num2], bl                             ; Store the result in num2

    ; Perform multiplication using Successive Addition
    call Succ_Add                              ; Call Successive Addition function
    PRINT msg3, msg3len                        ; Display the result header
    PRINT dispbuff, 4                          ; Print the result in hexadecimal
    PRINT newline, 1                           ; Print newline for formatting

    ; Perform multiplication using Shift and Add
    call Shift_Add                             ; Call Shift and Add function
    PRINT msg4, msg4len                        ; Display the result header
    PRINT dispbuff, 4                          ; Print the result in hexadecimal
    PRINT newline, 1                           ; Print newline for formatting

    ; Exit the program
    mov rax, 60                                ; System call number for sys_exit
    mov rdi, 0                                 ; Exit code 0
    syscall

; Convert ASCII hex input to actual hex value
Ascii_to_Hex:
    ; Convert first ASCII character to upper nibble
    mov bl, byte [ascii_num]                   ; Read first character
    sub bl, '0'                                ; Convert '0'-'9' to 0-9
    cmp bl, 9
    jbe Valid_Char                             ; If <= 9, valid character
    sub bl, 7                                  ; Convert 'A'-'F' to 10-15
Valid_Char:
    shl bl, 4                                  ; Shift left by 4 bits (upper nibble)

    ; Convert second ASCII character to lower nibble
    mov bh, byte [ascii_num + 1]               ; Read second character
    sub bh, '0'                                ; Convert '0'-'9' to 0-9
    cmp bh, 9
    jbe Valid_Char2                            ; If <= 9, valid character
    sub bh, 7                                  ; Convert 'A'-'F' to 10-15
Valid_Char2:
    or bl, bh                                  ; Combine upper and lower nibbles
    ret

; Perform multiplication using Successive Addition
Succ_Add:
    xor cx, cx                                 ; Clear CX (result accumulator)
    mov cl, [num2]                             ; Load multiplier into CL
    mov al, [num1]                             ; Load multiplicand into AL
.success_loop:
    test cl, cl                                ; Check if multiplier is zero
    jz .done                                   ; If zero, exit loop
    add cx, ax                                 ; Add multiplicand to result
    dec cl                                     ; Decrement multiplier
    jmp .success_loop                          ; Repeat loop
.done:
    mov ax, cx                                 ; Move result to AX
    call Hex_to_Ascii                          ; Convert result to ASCII
    ret

; Perform multiplication using Shift and Add
Shift_Add:
    xor cx, cx                                 ; Clear CX (result accumulator)
    mov al, [num1]                             ; Load multiplicand into AL
    mov bl, [num2]                             ; Load multiplier into BL
.shift_loop:
    test bl, 1                                 ; Check LSB of multiplier
    jz .skip_add                               ; If 0, skip addition
    add cx, ax                                 ; Add multiplicand to result
.skip_add:
    shl al, 1                                  ; Shift multiplicand left by 1
    shr bl, 1                                  ; Shift multiplier right by 1
    test bl, bl                                ; Check if multiplier is zero
    jnz .shift_loop                            ; If not zero, repeat loop
    mov ax, cx                                 ; Move result to AX
    call Hex_to_Ascii                          ; Convert result to ASCII
    ret

; Convert a 16-bit number in AX to a 4-digit hexadecimal string
Hex_to_Ascii:
    mov di, dispbuff + 4                       ; Point DI to end of buffer
    mov cx, 4                                  ; Process 4 digits
.hex_loop:
    dec di                                     ; Move to the previous position
    mov bx, ax                                 ; Copy AX to BX
    and bx, 0xF                                ; Mask the lower nibble
    add bx, '0'                                ; Convert to ASCII
    cmp bx, '9'                                ; Check if > '9'
    jbe .valid_hex                             ; If <= '9', valid character
    add bx, 7                                  ; Convert to 'A'-'F'
.valid_hex:
    mov byte [di], bl                          ; Store ASCII character in buffer
    shr ax, 4                                  ; Shift AX right by 4 bits
    loop .hex_loop                             ; Repeat for next digit
    ret
