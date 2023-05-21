; 21415 - Vedant Kokane , Batch - E4

section .data
	 m1 db 10,'Real Mode'
	rmsg_len:equ $- m1

	 m2 db 10,'Protected Mode'
	pmsg_len:equ $- m2

	 m3 db 10,'GDT ::'
	gmsg_len:equ $- m3

	 m4 db 10,'LDT ::'
	lmsg_len:equ $- m4

	 m5 db 10,'IDT ::'
	imsg_len:equ $- m5

	 m6 db 10,'Task Register ::'
	tmsg_len: equ $- m6

	 m7 db 10,'MSW::'
	mmsg_len:equ $- m7

	colmsg db ':'

	nwline db 10

section .bss
	gdt resd 1
	    resw 1
	ldt resw 1
	idt resd 1
	    resw 1
	tr  resw 1

	cr0_data resd 1

	dnum_buff resb 04

%macro print 2
	mov rax,01
	mov rdi,01
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro


section .text
global _start
_start:	
	smsw eax		;Reading CR0. As MSW is 32-bit cannot use RAX register. 

	mov [cr0_data],rax

	bt rax,1		;Checking PE bit, if 1=Protected Mode, else Real Mode
	jc prmode
	print  m1,rmsg_len
	jmp nxt1

prmode:	print  m2,pmsg_len

nxt1:	sgdt [gdt]
	sldt [ldt]
	sidt [idt]
	str [tr]
	print  m3,gmsg_len
	
	mov bx,[gdt+4]
	call print_num

	mov bx,[gdt+2]
	call print_num

	print colmsg,1

	mov bx,[gdt]
	call print_num

	print  m4,lmsg_len
	mov bx,[ldt]
	call print_num

	print  m5,imsg_len
	
	mov bx,[idt+4]
	call print_num

	mov bx,[idt+2]
	call print_num

	print colmsg,1

	mov bx,[idt]
	call print_num

	print  m6,tmsg_len
	
	mov bx,[tr]
	call print_num

	print  m7,mmsg_len
	
	mov bx,[cr0_data+2]
	call print_num

	mov bx,[cr0_data]
	call print_num

	print nwline,1


exit:	mov rax,60
	xor rdi,rdi
	syscall

print_num:
	mov rsi,dnum_buff	

	mov rcx,04		

up1:
	rol bx,4		
	mov dl,bl		
	and dl,0fh	
	add dl,30h		
	cmp dl,39h		
	jbe skip1		
	add dl,07h		
skip1:
	mov [rsi],dl	
	inc rsi			
	loop up1	
	print dnum_buff,4	
	ret

; nasm -f elf64  assignment_7.asm
; ld -o assignment_7 Assignment_7.o
; ./assignment_7

; Protected Mode
; GDT ::00032000:007F
; LDT ::0000
; IDT ::00000000:0FFF
; Task Register ::0040
; MSW::8005FFFF

