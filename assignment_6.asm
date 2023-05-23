; 21415 - Vedant Kokane , Batch - E4

section .data
    menumsg db 10,10,'---------------------------------------'
        db 10,'1: HEX to BCD'
        db 10,'2: BCD to HEX'
        db 10,'3: Exit'
        db 10,'---------------------------------------'
        db 10,10,'Enter Choice::'
    menumsg_len equ $-menumsg
  

    hexinmsg db 10,10,'Enter 4 digit hex number::'
    hexinmsg_len equ $-hexinmsg

    bcdopmsg db 10,10,'BCD :'
    bcdopmsg_len equ $-bcdopmsg

    bcdinmsg db 10,10,'Enter 5 digit BCD number::'
    bcdinmsg_len equ $-bcdinmsg

    hexopmsg db 10,10,'Hex :'
    hexopmsg_len equ $-hexopmsg



section .bss

    numascii resb 06  
    outputbuff resb 02
    dispbuff resb 08

    %macro display 2
       mov rax,01
       mov rdi,01
       mov rsi,%1
       mov rdx,%2
       syscall
    %endmacro

       %macro accept 2
      mov rax,0
      mov rdi,0
      mov rsi,%1
      mov rdx,%2
      syscall
       %endmacro

section .text

    global _start
_start:

menu:    display menumsg,menumsg_len
    accept numascii,2

    cmp byte [numascii],'1'
    je hex2bcd_proc



    cmp byte [numascii],'2'
    je bcd2hex_proc
  

    cmp byte [numascii],'3'
    je exit
    jmp _start

exit:
    mov rax,60
    mov rbx,0
    syscall

hex2bcd_proc:
    display hexinmsg,hexinmsg_len
    accept numascii,5
    call packnum
    mov ax,bx  
    mov rcx,0
    mov bx,10        
h2bup1:    mov dx,0
    div bx
    push rdx
    inc rcx
    cmp ax,0
    jne h2bup1
    mov rdi,outputbuff

h2bup2:    pop rdx
    add dl,30h
    mov [rdi],dl
    inc rdi
    loop h2bup2
  
    display bcdopmsg,bcdopmsg_len
    display outputbuff,5
    jmp menu

bcd2hex_proc:
    display bcdinmsg,bcdinmsg_len
    accept numascii,6

    display hexopmsg,hexopmsg_len

    mov rsi,numascii
    mov rcx,05
    mov rax,0
    mov ebx,0ah

b2hup1:    mov rdx,0
    mul ebx
    mov dl,[rsi]
    sub dl,30h
    add rax,rdx
    inc rsi
    loop b2hup1
    mov ebx,eax
    call disp32_num
    jmp menu

packnum:
    mov bx,0
    mov ecx,04
    mov esi,numascii
up1:
    rol bx,04
    mov al,[esi]
    cmp al,39h
    jbe skip1
    sub al,07h
skip1:    sub al,30h
    add bl,al
    inc esi
    loop up1
    ret


disp32_num:
    mov rdi,dispbuff    
    mov rcx,08      

dispup1:
    rol ebx,4      
    mov dl,bl       
    and dl,0fh       
    add dl,30h    
    cmp dl,39h       
    jbe dispskip1       
    add dl,07h        

dispskip1:
    mov [rdi],dl        
    inc rdi            
    loop dispup1        
                

    display dispbuff+3,5   
  
    ret


; nasm -f elf64  assignment_6.asm
; ld -o assignment_6 assignment_6.o
; ./assignment_6

; example input: 
; 1
; 000000000000FFFF
; output - 0000000000065535
; and vice versa
