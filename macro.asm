%macro io 4
	mov rax, %1
	mov rdi, %2
	mov rsi, %3
	mov rdx, %4
	syscall
%endmacro


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
        io 1, 1, msg1, msg1_len
		io 0, 0, name, 100
		mov [len], rax

		io 1, 1, msg2, msg2_len
		io 1, 1, name, [len]
        mov rax, 60
        mov rdi, 0
        syscall
