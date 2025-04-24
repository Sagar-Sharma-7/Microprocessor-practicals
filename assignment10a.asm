; File 1: Main Program
; Problem Statement: Write X86 ALP to find:
; a) Number of Blank spaces
; b) Number of lines
; c) Occurrence of a particular character
; Accept the data from the text file. The text file has to be accessed during Program_1 execution, and FAR PROCEDURES must be used in Program_2 for the rest of the processing. Use of PUBLIC and EXTERN directives is mandatory.

;************************************************************

extern    far_proc            ; [ FAR PROCEDURE USING EXTERN DIRECTIVE ]

global    filehandle, char, buf, abuf_len

%include  "macro2.asm"

;************************************************************
section .data
    nline       db    10
    nline_len   equ   $-nline

    ano         db    10,"Write X86 ALP to find, a) Number of Blank spaces b) Number of lines c) Occurrence of a particular character. Accept the data from the text file. The text file has to be accessed during Program_1 execution and write FAR PROCEDURES in Program_2 for the rest of the processing. Use of PUBLIC and EXTERN directives is mandatory",10, "Name:- Sagar",10,"Roll:- 7248",10,"Date of Performance:- 17/04/2025",10
                db    10,"---------------------------------------------------",10
    ano_len     equ   $-ano

    filemsg     db    10,"Enter filename for string operation    : "
    filemsg_len equ   $-filemsg   

    charmsg     db    10,"Enter character to search    : "
    charmsg_len equ   $-charmsg

    errmsg      db    10,"ERROR in opening File...",10
    errmsg_len  equ   $-errmsg

    exitmsg     db    10,10,"Exit from program...",10,10
    exitmsg_len equ   $-exitmsg

;************************************************************
section .bss
    buf         resb  4096
    buf_len     equ   $-buf        ; Buffer initial length

    filename    resb  50   
    char        resb  2   

    filehandle  resq  1
    abuf_len    resq  1            ; Actual buffer length

;************************************************************
section .text
    global _start
       
_start:
        display    ano,ano_len        ; Display assignment details

        display    filemsg,filemsg_len       
        accept     filename,50
        dec        rax
        mov        byte[filename + rax],0  ; Add null terminator

        display    charmsg,charmsg_len       
        accept     char,2
       
        fopen      filename            ; Open file (returns handle)
        cmp        rax,-1H             ; On failure, returns -1
        jle        Error
        mov        [filehandle],rax   

        fread      [filehandle],buf,buf_len ; Read file into buffer
        mov        [abuf_len],rax

        call       far_proc
        jmp        Exit

Error:  
        display    errmsg,errmsg_len   ; Display error message

Exit:  
        display    exitmsg,exitmsg_len ; Exit program
   
        display    nline,nline_len

        mov        rax,60
        mov        rdi,0
        syscall
