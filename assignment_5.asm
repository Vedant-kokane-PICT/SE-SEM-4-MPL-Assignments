; 21415 - Vedant Kokane , Batch - E4

%macro read_write 4
  mov rax,%1
  mov rdi,%2
  mov rsi,%3
  mov rdx,%4
  syscall
%endmacro

section .data
	msg1 db "positive - ",10
	l1 equ $-msg1
	msg2 db "negative - ",10
	l2 equ $-msg2
	; static array
	arr db -22h,12h,11h,55h
	
section .bss
	p resb 2
	n resb 2
	c resb 2
	total resb 2
	
section .text
	global _start
_start:
mov byte[c],04
mov byte[p],00
mov byte[n],00
mov rsi,arr

traverse: 
	mov al,00
	add al,[rsi]
	js negative_inc
	inc byte[p]
	jmp counter
	

negative_inc:
	inc byte[n]
	counter:
	add rsi,01
	dec byte[c]
	jnz traverse
mov bl,byte[p]
mov dl,byte[n]


print:
	read_write 1,1,msg1,l1
	mov bh,byte[p]
	call disp
	
	read_write 1,1,msg2,l2
	mov bh,byte[n]
	call disp
	
mov rax,60
mov rdi,00
syscall

disp:
	mov byte[c],02
	loop:
		rol bh,04
		mov al,bh
		and al,0FH
		cmp al,09
		jbe label1
		add al,07h
		label1:
			add al,30h
		mov[total],al
		read_write  1,1,total,02
		dec byte[c]
		jnz loop
	ret
	
; nasm -f elf64  assignment_5.asm
; ld -o assignment_5 assignment_5.o
; ./assignment_5
