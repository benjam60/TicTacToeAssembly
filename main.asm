
%define  ReadFileDescriptor  0

section .data
	NUMCELLS: dd 9
	NUMROWS: dd 3
	ROWSIZE: dd 3
	EMPTY: dd 95
	NEWLINE: db 0xa, 0xd
	NEWLINELENGTH: equ $-NEWLINE

section .bss
	INPUT: resd 3
	BOARD: resd 9	

global start

section .text
start:
	and esp, -16
	mov esi, 0
	call initializeBoard
	call printArray
	jmp finish

initializeBoard:
	mov edi, [NUMCELLS]
	mov eax, BOARD
	add eax, esi
	mov ebx, [EMPTY]
	mov [eax], ebx
	add esi, 1
	cmp esi, edi
	jne initializeBoard
	ret

printArray:
	mov esi, 0
	mov edi, [NUMROWS]
	call printArrayLine
	ret

printArrayLine:
	push dword [ROWSIZE]
	mov eax, BOARD
	push dword eax
	push dword 1
	mov eax, 4 
	sub esp, 4
	int 0x80	
	add esp, 16
	call printNewLine
	add esi, 1
       	cmp esi, edi
	jne printArrayLine
	ret 

printNewLine:
	;Print new line after the output 
	mov eax, WriteFileDescriptor
	push dword NEWLINELENGTH
	push dword NEWLINE
	push dword 1
	sub esp, 4
	int 0x80
	add esp, 16
	ret

readInput:
	push dword 1
	push dword INPT
	push dword ReadFileDescriptor
	mov eax, 3
	int 0x80
	add esp,16
	ret

finish:
	push dword 0
	mov eax, 1
	sub esp, 4
	int 0x80
