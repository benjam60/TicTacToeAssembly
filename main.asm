
%define  ReadFileDescriptor  0

section .data
	NUMCELLS: dd 9
	NUMROWS: dd 3
	ROWSIZE: dd 3
	EMPTY: dd 95
	NEWLINE: db 0xa, 0xd
	NEWLINELENGTH: equ $-NEWLINE

section .bss
	INPUT: resd 10
	BOARD: resd 9	

global start

section .text
start:
	and esp, -16
	mov esi, 0
	call initializeBoard
	call printBoard
	jmp gameLoop

gameLoop:
	call readInput
	call updateBoard
	call printBoard
	jmp gameLoop

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

printBoard:
	mov esi, 0
	mov edi, [NUMROWS]
	call printBoardLine
	ret

printBoardLine:
	push dword [ROWSIZE]
	mov eax, esi
	imul eax, 3
	add eax, BOARD 
	push dword eax
	push dword 1
	mov eax, 4 
	sub esp, 4
	int 0x80	
	add esp, 16
	call printNewLine
	add esi, 1
       	cmp esi, edi
	jne printBoardLine
	ret 

printNewLine:
	;Print new line after the output 
	mov eax, 4 
	push dword NEWLINELENGTH
	push dword NEWLINE
	push dword 1
	sub esp, 4
	int 0x80
	add esp, 16
	ret

readInput:
	push dword 10
	push dword INPUT
	push dword ReadFileDescriptor
	mov eax, 3
	sub esp, 4
	int 0x80
	add esp,16
	ret

updateBoard:
	mov eax, 0
	mov al, [INPUT]
	sub eax, 48 ; char to int
	mov ebx, BOARD
	add eax, ebx
	mov byte [eax], 'X'
	ret

finish:
	push dword 0
	mov eax, 1
	sub esp, 4
	int 0x80
