section .data
	msg db 'Hello World', 10
	msglen equ $-msg

section .code
	global _start
	_start:
		mov rax, 1
		mov rdi, 1
		mov rsi, msg
		mov rdx, msglen
		syscall

		; exit the program
		mov rax, 60
		mov rdi, 0
		syscall
