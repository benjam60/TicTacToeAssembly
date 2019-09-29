section .data
	NUMCELLS: dd 9
	NUMROWS: dd 3
	ROWSIZE: dd 3
	EMPTY: dd 95
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
	add esi, 1
	cmp esi, edi
	jne printArrayLine
	ret 


finish:
	push dword 0
	mov eax, 1
	sub esp, 4
	int 0x80
