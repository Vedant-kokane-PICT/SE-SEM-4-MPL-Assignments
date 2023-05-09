; 21415 - Vedant Kokane , Batch - E4

%macro read_write 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro
section .data
	m1 db "Enter five 64 bit numbers:" ,10 
    l1 equ $-m1                         
    m2 db "Five 64 bit numbers are:" ,10   
    l2 equ $-m2 
    m7 db 10
	time equ 5
	size equ 8
	
section .bss
	arr resb 300
	_input resb 20
	_output resb 20
	count resb 1
section .text
	global _start
	_start:
    mov byte[count],time 
	mov rbp,arr     
	read_write 1,1,m1,l1
input:	
    read_write 0,0,_input,17
    
	call ascii_to_hex
    mov [rbp],rbx  
	add rbp,size
	dec byte[count] 
	jnz input

	mov byte[count],time 
	mov rbp,arr     
	jmp display
display:	
    mov rax,[rbp]  
	call hex_to_ascii
	read_write 1,1,m7,1
	read_write 1,1,_output,16
	add rbp,size
	dec byte[count] 
	jnz display
	jmp exit
exit:	
	mov rax,60
	mov rdi,0
	syscall
error:
    jmp exit
ascii_to_hex:
    	mov rsi,_input
    	mov rcx,16
    	xor rbx,rbx  
        xor rax,rax  
    letter:	
        rol rbx,4    
    	mov al,[rsi] 
    	cmp al,47h   
    	jge error    
    	cmp al,39h   
    	jbe skip     
    	sub al,07h   
    skip:	
        sub al,30h  
    	add rbx,rax  
    	inc rsi     
    	dec rcx      
    	jnz letter
    ret	
hex_to_ascii:
        mov rsi,_output+15  
        mov rcx,16           
    letter2:	
        xor rdx,rdx
        mov rbx,16          
        div rbx          
        cmp dl,09h          
        jbe add30            
        add dl,07h          
    add30:	
        add dl,30h          
        mov [rsi],dl         
        dec rsi              
        dec rcx                 
        jnz letter2
ret
	
; nasm -f elf64  assignment_1.asm
; ld -o assignment_1 assignment_1.o
; ./assignment_1

; example  input -  
; 5555555555555555
; 4444444444444444
; 3333333333333333
; 2222222222222222
; 1111111111111111 

