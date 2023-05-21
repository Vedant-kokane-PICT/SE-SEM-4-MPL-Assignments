; 21415 - Vedant Kokane , Batch - E4

%macro read_write 4
        mov rax,%1
        mov rdi,%2
        mov rsi,%3
        mov rdx,%4
        syscall
%endmacro

section .data
        menu db 10d,13d,"--------------------"
             db 10d,"1. HEX to BCD"
             db 10d,"2. BCD to HEX"
             db 10d,"3. Exit"
             db 10d,"Enter your choice: "
        menulen equ $-menu
        m1 db 10d,13d,"Enter HEX Number: "
        l1 equ $-m1
        m2 db 10d,13d,"Enter BCD Number: "
        l2 equ $-m2
        
        m3 db 10d,13d,"Equivalent BCD Number: "
        l3 equ $-m3
        m4 db 10d,13d,"Equivalent HEX Number: "
        l4 equ $-m4
        
section .bss
        choice resb 1
        num resb 16
        answer resb 16
        factor resb 16
        
section .code
        global _start
_start:
        
        read_write 1,1,menu,menulen
        read_write 0,0,choice,2
        
        cmp byte[choice],'3'
        jae exit
        cmp byte[choice],'1'
        je hex2bcd
        cmp byte[choice],'2'
        je bcd2hex
            
hex2bcd:
        read_write 1,1,m1,l1
        read_write 0,0,num,17
        call asciihextohex
        
        mov rax,rbx
	mov rbx,10
	mov rdi,num+15
loop3:
	mov rdx,0
	div rbx
	add dl,30h
	mov [rdi],dl
	dec rdi
	cmp rax,0
	jne loop3
	             
        read_write 1,1,m3,l3
        read_write 1,1,num,16          
jmp _start


bcd2hex:        
        read_write 1,1,m2,l2
        read_write 0,0,num,17  
                
        mov rcx,16
	mov rsi,num+15
	mov rbx,0
	mov qword[factor],1
	
loop4:
	mov rax,0	
	mov al,[rsi]
        sub al,30h
	mul qword[factor]
	add rbx,rax
	mov rax,10
	mul qword[factor]
	mov qword[factor],rax
	dec rsi
	loop loop4

	read_write 1,1,m4,l4
	mov rax,rbx
	call display            
jmp _start     
   
exit:   
        mov rax,60
        mov rdx,0
        syscall
        
        

	
asciihextohex:
	mov rsi,num
	mov rcx,16
	mov rbx,0
	mov rax,0
		
loop1:	rol rbx,04
	mov al,[rsi]
	cmp al,39h
	jbe skip1
	sub al,07h
skip1:	sub al,30h
	
	add rbx,rax
	
	inc rsi
	dec rcx
	jnz loop1	
ret	

display:
        mov rsi,answer+15
        mov rcx,16

loop2:	mov rdx,0
        mov rbx,16
        div rbx
        cmp dl,09h
        jbe skip2
        
        add dl,07h
skip2:	add dl,30h
        mov [rsi],dl
        
        dec rsi
        dec rcx
        jnz loop2
        read_write 1,1,answer,16       
ret


; nasm -f elf64  assignment_6.asm
; ld -o assignment_6 Assignment_6.o
; ./assignment_6

; example input: 
; 1
; 000000000000FFFF
; output - 0000000000065535
; and vice versa
