%macro io 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall	
%endmacro

section .data
	msg1 db "Write an X86/64 ALP to accept five hexadecimal numbers from user and store them in an array and display the accepted numbers.",10
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
