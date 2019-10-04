
%define  ReadFileDescriptor  0

section .data
	NUMCELLS: dd 9
	NUMROWS: dd 3
	ROWSIZE: dd 3
	EMPTY: dd 95
	NEWLINE: db 0xa, 0xd
	NEWLINELENGTH: equ $-NEWLINE
	WINNERMSG: db "Winner", 0
	XTURNPROMPT: db "X, it your turn", 0, 10
	XTURNPROMPTLEN: equ $ - XTURNPROMPT
	OTURNPROMPT: db "O, it your turn", 0, 10
	OTURNPROMPTLEN: equ $ - OTURNPROMPT


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
	call printXPrompt
	call readInput
	call updateXBoard
	call checkWinner
	call printBoard
	call printOPrompt
	call readInput
	call updateOBoard
	call checkWinner
	call printBoard
	jmp gameLoop

	
checkWinner:
	mov eax, [BOARD]
	and eax, 0x00FFFFFF ;get the first 3 characters
	cmp eax, 0x00585858 ; compare to row of Xs
	je winner
	cmp eax, 0x004F4F4F ; compare to row of Os
	je winner
	call checkVerticalWinner
	ret

checkVerticalWinner:
	mov eax, 0
	mov al, [BOARD] ;get first column first row
	shl eax, 8
	mov al, [BOARD + 3] ;get first column 2nd row
	shl eax, 8
	mov al, [BOARD + 6] ;get first column 3rd row
	cmp eax, 0x00585858
	je winner
	cmp eax, 0x004F4F4F
	je winner
	ret

winner:
	call printBoard
	call printWinner
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
	mov eax, 4 
	push dword NEWLINELENGTH
	push dword NEWLINE
	push dword 1
	sub esp, 4
	int 0x80
	add esp, 16
	ret

printWinner:
	mov eax, 4 
	push dword 7 
	push dword WINNERMSG
	push dword 1
	sub esp, 4
	int 0x80
	add esp, 16
	ret

printXPrompt:
	mov eax, 4 
	push dword XTURNPROMPTLEN 
	push dword XTURNPROMPT
	push dword 1
	sub esp, 4
	int 0x80
	add esp, 16
	ret


printOPrompt:
	mov eax, 4
 	push dword OTURNPROMPTLEN 
	push dword OTURNPROMPT
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

updateXBoard:
	mov eax, 0
	mov al, [INPUT]
	sub eax, 48 ; char to int
	mov ebx, BOARD
	add eax, ebx
	mov byte [eax], 'X'
	ret

updateOBoard:
	mov eax, 0
	mov al, [INPUT]
	sub eax, 48 ; char to int
	mov ebx, BOARD
	add eax, ebx
	mov byte [eax], 'O'
	ret


finish:
	push dword 0
	mov eax, 1
	sub esp, 4
	int 0x80
