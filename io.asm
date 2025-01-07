section .data
    msg1 db 'Enter your name: ', 20H
    msg1_len equ $-msg1
    msg2 db 'Your name is: ', 20H
    msg2_len equ $-msg2

section .bss
    name resb 100
	len resb 1

section .text
    global _start
    _start:
        mov rax, 1
        mov rdi, 1
        mov rsi, msg1
        mov rdx, msg1_len
        syscall

        mov rax, 0
        mov rdi, 0
        mov rsi, name
        mov rdx, 100
        syscall
		
		mov [len], rax

        mov rax, 1
        mov rdi, 1
        mov rsi, msg2
        mov rdx, msg2_len
        syscall

        mov rax, 1
        mov rdi, 1
        mov rsi, name
        mov rdx, [len]
        syscall

        mov rax, 60
        mov rdi, 0
        syscall
