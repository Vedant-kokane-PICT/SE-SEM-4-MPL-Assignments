; 21415 - Vedant Kokane , Batch - E4

%macro  read_write 4			
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	num db 00h
	msg db "Factorial is : "
	msglen equ $-msg
	zerofact db " 00000001 "
	zerofactlen equ $-zerofact

section .bss
	dispnum resb 16
	result resb 4
	temp resb 3
	

section .text
global _start
_start:
	
	read_write 0,0,temp,3		
	call convert		
	mov [num],dl
	
	  read_write 1,1,msg,msglen
	
	xor rdx,rdx
	xor rax,rax
	mov al,[num]		
	cmp al,01h			
	jbe endfact
	xor rbx,rbx
	mov bl,01h
	call factr		
	call display

	call exit
endfact:
	  read_write 1,1,zerofact,zerofactlen
	call exit

	factr:				
			cmp rax,01h
			je retcon1
			push rax			
			dec rax
			
			call factr

		retcon:
			pop rbx
			mul ebx
			jmp endpr

		retcon1:			
			pop rbx
			jmp retcon		
		endpr:
	
	ret

	display:		
	
			mov rsi,dispnum+15
			xor rcx,rcx
			mov cl,16

		cont:
			xor rdx,rdx
			xor rbx,rbx
			mov bl,10h
			div ebx
			cmp dl,09h
			jbe skip
			add dl,07h
		skip:
			add dl,30h
			mov [rsi],dl
			dec rsi
			loop cont
	
			  read_write 1,1,dispnum,16
	
	ret

	convert:			
			mov rsi,temp
			mov cl,02h
			xor rax,rax
			xor rdx,rdx
		contc:
			rol dl,04h
			mov al,[rsi]
			cmp al,39h
			jbe skipc
			sub al,07h
		skipc:
			sub al,30h
			add dl,al
			inc rsi
			dec cl
			jnz contc
	
	ret

	exit:				
				
			mov rax,60
			mov rdi,0
			syscall

	ret

; nasm -f elf64  assignment_10.asm
; ld -o assignment_10 assignment_10.o
; ./assignment_10
