%macro io 4
	mov rax,%1          ; Set syscall number in rax (1 for write)
	mov rdi,%2          ; Set file descriptor in rdi (1 for stdout)
	mov rsi,%3          ; Set pointer to the buffer in rsi
	mov rdx,%4          ; Set length of the buffer in rdx
	syscall             ; Make the syscall
%endmacro

section .data
	msg1 db "Write 64 ALP to accept a string from user and display the length.",10
	msg1len equ $-msg1
	msg2 db "Enter string: ",10
	msg2len equ $-msg2
	msg3 db "The length of string is: ",10
	msg3len equ $-msg3
	newline db 10

section .bss
	string resb 20
	len resb 1
	lens resb 2

section .data
	global _start
	_start:
		io 1,1,msg1,msg1len
		io 1,1,msg2,msg2len
		io 0,0,string,20
		dec rax
		mov [len],rax

		io 1,1,msg3,msg3len
		
		mov bl,[len]
		call hex_ascii64
		
		mov rax,60
		mov rdi,0
		syscall

hex_ascii64:
	mov rsi,lens
	mov rcx,2
	
	next2: 	
		rol bl,4
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
		io 1,1,lens,2
		io 1,1,newline,1
	ret
	
