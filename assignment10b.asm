; File 2: Far Procedure
; Problem Statement: Write X86 ALP to find:
; a) Number of Blank spaces
; b) Number of lines
; c) Occurrence of a particular character

;************************************************************
global    far_proc       

extern    filehandle, char, buf, abuf_len

%include  "macro2.asm"
;************************************************************
section .data
    nline       db    10,10
    nline_len   equ   $-nline

    smsg        db    10,"No. of spaces are    : "
    smsg_len    equ   $-smsg
    
    nmsg        db    10,"No. of lines are    : "
    nmsg_len    equ   $-nmsg

    cmsg        db    10,"No. of character occurrences are    : "
    cmsg_len    equ   $-cmsg

;************************************************************
section .bss
    scount      resq  1
    ncount      resq  1
    ccount      resq  1

    dispbuff    resb  4

;************************************************************
section .text

far_proc:                  ; FAR Procedure
    
        mov    rax,0
        mov    rbx,0
        mov    rcx,0
        mov    rsi,0   

        mov    bl,[char]           ; Character to search
        mov    rsi,buf             ; Pointer to buffer
        mov    rcx,[abuf_len]      ; Buffer length

again:  
        mov    al,[rsi]            ; Read one byte

case_s: 
        cmp    al,20h              ; Check if space
        jne    case_n
        inc    qword[scount]       ; Increment space count
        jmp    next

case_n: 
        cmp    al,0Ah              ; Check if newline
        jne    case_c
        inc    qword[ncount]       ; Increment line count
        jmp    next

case_c: 
        cmp    al,bl               ; Check if match character
        jne    next
        inc    qword[ccount]       ; Increment character count

next:  
        inc    rsi
        dec    rcx                 ; Decrement loop counter
        jnz    again               ; Repeat if not zero

        display smsg,smsg_len
        mov    rbx,[scount]
        call   display16_proc
    
        display nmsg,nmsg_len
        mov    rbx,[ncount]
        call   display16_proc

        display cmsg,cmsg_len
        mov    rbx,[ccount]
        call   display16_proc

        fclose  [filehandle]       ; Close file
        ret

;************************************************************
display16_proc:
        mov    rdi,dispbuff        ; Point buffer
        mov    rcx,4               ; Load number of digits to display 

dispup1: 
        rol    bx,4                ; Rotate number left by four bits
        mov    dl,bl               ; Move lower byte
        and    dl,0fh              ; Mask upper digit
        add    dl,30h              ; Convert to ASCII
        cmp    dl,39h              ; Compare with '9'
        jbe    dispskip1           ; Skip if <= '9'
        add    dl,07h              ; Adjust for letters

dispskip1: 
        mov    [rdi],dl            ; Store ASCII code
        inc    rdi                 ; Next byte
        loop   dispup1             ; Loop

        display dispbuff,4         ; Display buffer
        ret
