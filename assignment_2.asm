; 21415 - Vedant Kokane , Batch - E4

%macro input 2
  mov rax,0
  mov rdi,0
  mov rsi,%1
  mov rdx,%2
  syscall
%endmacro

%macro output 2
  mov rax,1
  mov rdi,1
  mov rsi,%1
  mov rdx,%2
  syscall
%endmacro

section .data
  m1 db "Enter string "
  l1 equ $-m1
  
section .bss
    string resb 100                      
    strl equ $-string 
    res resb 100
  
section .text
    global _start
_start:
    output m1,l1
    input string,strl
    call disp	
    syscall
mov rax,60
mov rdi,0
syscall

disp:
    mov rbx,rax 
    mov rdi, res 
    mov cx,16 
up1:
    rol rbx,04 
    mov al,bl 
    and al,0fh 
    cmp al,09h 
    jg add_37 
    add al,30h
    dec al
    jmp skip 
add_37 : add al,37h
skip:
    mov [rdi],al
    ;inc rdi
    dec cx 
    jnz up1 
    output string, 50
    output res,2
    ret

; nasm -f elf64  assignment_2.asm --> used for compiling
; ld -o assignment_2 assignment_2.o
; ./assignment_2
; example input -- vedant 
; output is 6
; give 1 space after input
