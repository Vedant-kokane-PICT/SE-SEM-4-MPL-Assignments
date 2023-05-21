; 21415 - Vedant Kokane , Batch - E4

section .data
        nline 		db	10,10
	nline_len	equ	$-nline
	space		db	" "
	 m1		db	10,"Before Transfer::"
	 m1_len	equ	$- m1

	 m2		db	10,"After Transfer::"
	 m2_len	equ	$- m2
	
	 m3		db	10,"	Source Block		:"
	 m3_len	equ	$- m3

	 m4		db	10,"	Destination Block	:"
	 m4_len	equ	$- m4

	sblock		db	10h,20h,30h,40h,50h
	dblock		times	5	db	0
	

section .bss
	char_ans resB	2	
	
%macro	Print	2
	 MOV	RAX,1
	 MOV	RDI,1
         MOV	RSI,%1
         MOV	RDX,%2
    syscall
%endmacro

%macro	Read	2
	 MOV	RAX,0
	 MOV	RDI,0
         MOV	RSI,%1
         MOV	RDX,%2
    syscall
%endmacro


%macro Exit 0
	Print	nline,nline_len
	MOV	RAX,60
        MOV	RDI,0
    syscall
%endmacro
    

section .text
	global _start

_start:
	Print	 m1, m1_len	
	Print 	 m3, m3_len
	mov	rsi,sblock
	call	disp_block	
	Print	 m4, m4_len
	mov	rsi,dblock
	call	disp_block
	call	BT_NO		
	Print	 m2, m2_len
	Print 	 m3, m3_len
	mov	rsi,sblock
	call	disp_block
	Print	 m4, m4_len
	mov	rsi,dblock
	call	disp_block

Exit

BT_NO:
	mov	rsi,sblock
	mov	rdi,dblock
	mov	rcx,5

back:	mov	al,[rsi]	
	mov	[rdi],al	
	inc	rsi
	inc	rdi
	dec	rcx
	jnz	back
RET


disp_block:
	mov	rbp,5		

next_num:
	mov	al,[rsi]	
	push	rsi		

	call	Disp_8
	Print	space,1
	
	pop	rsi		
	inc	rsi
	
	dec	rbp
	jnz	next_num
RET

Disp_8:
	MOV	RSI,char_ans+1
	MOV	RCX,2           
	MOV	RBX,16		

next_digit:
	XOR	RDX,RDX
	DIV	RBX

	CMP	DL,9	
	JBE	add30
	ADD	DL,07H

add30	:
	ADD	DL,30H
	MOV	[RSI],DL
	DEC	RSI
	DEC	RCX
	JNZ	next_digit
	Print	char_ans,2
ret



; nasm -f elf64  assignment_8.asm
; ld -o assignment_8 assignment_8.o
; ./assignment_8
