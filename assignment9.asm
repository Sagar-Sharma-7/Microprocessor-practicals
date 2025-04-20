; Write X86 menu driven Assembly Language Program (ALP) to implement OS (DOS) commands TYPE, COPY and DELETE using file operations. 
; User is supposed to provide command line arguments in all cases.
%include "macro.asm"

section .data
	dispMsg db "Write X86 menu driven Assembly Language Program (ALP) to implement OS (DOS) commands TYPE, COPY and DELETE using file operations. User is supposed to provide command line arguments in all cases.",10, "Name:- Sagar",10,"Roll:- 7248", 10
	dispMsglen equ $-dispMsg
	msg db "------------------MENU------------------", 10
	    db "	1. TYPE ", 10
	    db "	2. COPY ", 10
	    db "	3. DELETE ", 10
	    db "	4. Exit ", 10
	    db "Enter your choice : "
	msglen equ $-msg
	endl db 10
	m db "DONE!", 0ah
	
	
section .bss
	choice resb 2
	fname1 resb 50
	fname2 resb 50
	
	filehandle1 resq 1
	filehandle2 resq 1
	
	buffer resb 100
	bufferlen resb 1
	temp resb 16
	
section .text
	global _start
_start :
	pop rbx ; number of arguments 
	pop rsi ; executable program name
	write dispMsg, dispMsglen
	
	mov rdi, fname1
	mark :
	pop rsi ; the first argument name
	mov rdx, 0
	next :
		mov al, byte[rsi+rdx]
		mov [rdi+rdx], al
		cmp byte[rsi+rdx], 0
		
		je next1
		inc rdx
		jmp next
	next1 :
	
	cmp rdi, fname2
	je main_menu
	
	mov rdi, fname2
	jmp mark
	
	
	main_menu :
		write msg, msglen
		read choice, 2
		
		cmp byte[choice], "1"
		je case1
		
		cmp byte[choice], "2"
		je case2
		
		cmp byte[choice], "3"
		je case3
		
		cmp byte[choice], "4"
		je case4
	jmp main_menu
	
	
	case1 :
		call type
		jmp main_menu
	case2 :
		call copy
		jmp main_menu
	case3 :
		call delete
		jmp main_menu
	case4 :	
		mov rax, 60
		mov rdi, 0
		syscall
		
type :
	; open file in read mode using open interrupt 
	; read contents of file using read interrupt
	; display contents of file using write interrupt
	; close file using close interrupt
	
	fopen fname1
	
	cmp rax, -1h
	je case4
	
	mov [filehandle1], rax
	fread [filehandle1], buffer, 100
	
	dec rax
	mov [bufferlen], rax
	
	write fname1, 50
	write endl, 1
	write buffer, bufferlen
	write endl, 1
	
	fclose fname1 
	ret

copy :
	; open file in read mode using open interrupt
	; read contents of file using read interrupt
	; create another file using read interrupt change only attributes
	; open another file using open interrupt
	; write contents of buffer into operand file
	; close both files using close interrupt
	
	fopen fname1
	cmp rax, -1h
	je case4
	mov [filehandle1], rax
	
	fread [filehandle1], buffer, 1000
	mov [bufferlen], rax

	fcreate fname2
	cmp rax, -1h
	je case4
	mov [filehandle2], rax
	
	fwrite [filehandle2], buffer, [bufferlen]
	fclose fname1
	fclose fname2
	write m, 6
	ret

delete :
	; delete file using delete interrupt
	fdelete fname2	
	write m, 6
	ret	
