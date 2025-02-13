%macro io 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall	
%endmacro
%macro io 4
    ; Macro to simplify syscall usage for input/output
    ; %1: Syscall number (rax)
    ; %2: File descriptor (rdi) - 0 for stdin, 1 for stdout
    ; %3: Address of the buffer (rsi)
    ; %4: Length of the buffer (rdx)
    mov rax, %1        ; Set syscall number
    mov rdi, %2        ; Set file descriptor
    mov rsi, %3        ; Set buffer address
    mov rdx, %4        ; Set buffer length
    syscall            ; Perform the system call
%endmacro

section .data
    ; Static data section for storing messages and constants
    msg1 db "Write an X86/64 ALP to accept five hexadecimal numbers from user and store them in an array and display the accepted numbers.", 10, "Name: Sagar", 10, "Roll no: 7248", 10, "Date: 20/01/2025", 10
    msg1len equ $-msg1  ; Length of msg1
    msg2 db "Enter five 64-bit hexadecimal numbers: ", 10
    msg2len equ $-msg2  ; Length of msg2
    msg3 db "The five 64-bit hexadecimal numbers are: ", 10
    msg3len equ $-msg3  ; Length of msg3
    newline db 10       ; Newline character

section .bss
    ; Uninitialized data section for buffers and arrays
    ascii resb 17       ; Buffer for ASCII input (max 17 bytes, including null terminator)
    hexnum resq 5       ; Array to store 5 64-bit hexadecimal numbers

section .code
global _start

_start:
    ; Print the introduction message (msg1)
    io 1, 1, msg1, msg1len

    ; Prompt the user to enter numbers (msg2)
    io 1, 1, msg2, msg2len

    ; Initialize variables for the input loop
    mov rcx, 5          ; Loop counter (5 numbers to input)
    mov rsi, hexnum     ; Start address of hexnum array

next3:
    ; Loop to accept 5 hexadecimal numbers
    push rsi            ; Save current rsi value on the stack
    push rcx            ; Save current rcx value on the stack

    ; Read user input
    io 0, 0, ascii, 17  ; Read up to 17 bytes from stdin into ascii buffer
    call ascii_hex64    ; Convert ASCII string to a 64-bit hexadecimal number (stored in rbx)

    pop rcx             ; Restore rcx (loop counter)
    pop rsi             ; Restore rsi (array pointer)

    ; Store the converted number in the hexnum array
    mov [rsi], rbx      ; Save rbx (converted number) to the current array position
    add rsi, 8          ; Move to the next 64-bit slot in the array
    loop next3          ; Repeat until all 5 numbers are read

    ; Print the message for displaying the numbers (msg3)
    io 1, 1, msg3, msg3len

    ; Initialize variables for the output loop
    mov rsi, hexnum     ; Start address of hexnum array
    mov rcx, 5          ; Loop counter (5 numbers to output)

next4:
    ; Loop to display 5 hexadecimal numbers
    push rsi            ; Save current rsi value on the stack
    push rcx            ; Save current rcx value on the stack

    ; Convert and display the number
    mov rbx, [rsi]      ; Load the current number from the array into rbx
    call hex_ascii64    ; Convert the number to ASCII and print it

    pop rcx             ; Restore rcx (loop counter)
    pop rsi             ; Restore rsi (array pointer)
    add rsi, 8          ; Move to the next 64-bit slot in the array
    loop next4          ; Repeat until all 5 numbers are displayed

    ; Exit the program
    mov rax, 60         ; Syscall number for exit
    mov rdi, 0          ; Exit status (0 for success)
    syscall             ; Perform the exit syscall

; Function to convert an ASCII string to a 64-bit hexadecimal number
ascii_hex64:
    mov rsi, ascii      ; Load the address of the ASCII input buffer into rsi
    mov rbx, 0          ; Initialize rbx to 0 (to store the result)
    mov rcx, 16         ; Maximum of 16 hexadecimal digits to process

next1:
    ; Process each character in the ASCII buffer
    rol rbx, 4          ; Shift rbx left by 4 bits to make room for the next digit
    mov al, [rsi]       ; Load the current character into al
    cmp al, 39H         ; Check if the character is '0'-'9'
    jbe sub30h          ; If yes, jump to sub30h
    sub al, 7H          ; Adjust for 'A'-'F' (ASCII value to numeric value)

sub30h:
    sub al, 30H         ; Convert ASCII character to numeric value
    add bl, al          ; Add the digit to the result in rbx
    inc rsi             ; Move to the next character in the buffer
    loop next1          ; Repeat for all digits

    ret                 ; Return to caller

; Function to convert a 64-bit hexadecimal number to an ASCII string and print it
hex_ascii64:
    mov rsi, ascii      ; Load the address of the ASCII output buffer into rsi
    mov rcx, 16         ; Convert 16 hexadecimal digits (64-bit number)

next2:
    ; Process each 4-bit nibble of the number
    rol rbx, 4          ; Shift rbx left by 4 bits to extract the next nibble
    mov al, bl          ; Get the lowest 4 bits of rbx
    and al, 0fh         ; Mask to isolate the nibble
    cmp al, 9           ; Check if the nibble is 0-9
    jbe add30h          ; If yes, jump to add30h
    add al, 7H          ; Adjust for 'A'-'F'

add30h:
    add al, 30H         ; Convert numeric value to ASCII character
    mov [rsi], al       ; Store the character in the ASCII buffer
    inc rsi             ; Move to the next position in the buffer
    loop next2          ; Repeat for all nibbles

    ; Print the converted ASCII string and a newline
    io 1, 1, ascii, 16  ; Write the 16-character ASCII string to stdout
    io 1, 1, newline, 1 ; Write a newline to stdout

    ret                 ; Return to caller

section .data
	msg1 db "Write an X86/64 ALP to accept five hexadecimal numbers from user and store them in an array and display the accepted numbers.",10, "Name: Sagar", 10, "Roll no: 7248", 10, "Date: 20/01/2025", 10
	msg1len equ $-msg1
	msg2 db "Enter five 64-bit hexadecimal number: ",10
	msg2len equ $-msg2
	msg3 db "The five 64-bit hexadecimal number are: ",10
	msg3len equ $-msg3
	newline db 10

section .bss
	ascii resb 17
	hexnum resq 5

section .code
global _start

_start:
	io 1,1,msg1,msg1len
	io 1,1,msg2,msg2len

	mov rcx,5
	mov rsi,hexnum

	next3:
		push rsi
		push rcx
		io 0,0,ascii,17
		call ascii_hex64
		pop rcx
		pop rsi
		mov [rsi],rbx
		add rsi,8		
	loop next3

	io 1,1,msg3,msg3len
	
	mov rsi,hexnum
	mov rcx,5

	next4: 		
		push rsi
		push rcx
		mov rbx,[rsi]
		call hex_ascii64
		pop rcx
		pop rsi
		add rsi,8
	loop next4

	mov rax,60
	mov rdi,0
	syscall


ascii_hex64:
	mov rsi,ascii

	mov rbx,0
	mov rcx,16
	
	next1: 	
		rol rbx,4
		mov al,[rsi]
		cmp al,39H
		jbe sub30h
		sub al,7H
		
		sub30h: 
			sub al,30H
			add bl,al
			inc rsi
	loop next1

ret

hex_ascii64:
	mov rsi,ascii
	mov rcx,16
	
	next2: 	
		rol rbx,4
		mov al,bl
		and al,0fh
		cmp al,9
		jbe add30h
		add al,7H
		
		add30h: 
			add al,30H
			mov [rsi],al
			inc rsi
	loop next2
		io 1,1,ascii,16
		io 1,1,newline,1
	ret
