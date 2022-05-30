[org 0x0100]

    jmp start
	minus: dw "-"
	star: dw "|"
	plus: dw "+"


clrscr:     
    push es
    push ax
    push di

    mov  ax, 0xb800
    mov  es, ax
    mov  di, 0

    nextloc:
        mov  word [es:di], 0x0720
        add  di, 2
        cmp  di, 4000
        jne  nextloc

    pop  di 
    pop  ax
    pop  es
    ret


drawtri:
		
	push bp
	mov bp, sp
	sub sp, 2
	
	push ax
	push bx
	push cx
	push dx
	push si
	push di


	mov ax, 0xb800
	mov es, ax


	mov si, [bp+6]
	mov al, [si]
	mov ah, 0x07


	mov di, 3080

	loop1:
		mov word[es:di], ax
		add di, 2

		cmp di,3158
		jne loop1




	mov di, 80


	mov si, [bp+4]
	mov al, [si]
	mov ah, 0x07


	loop2:
		mov word[es:di], ax
		add di, 162

		cmp di,3158
		jne loop2

	
	


	

	mov di, 238


	mov si, [bp+8]
	mov al, [si]
	mov ah, 0x07


	loop3:
		mov word[es:di], ax
		add di, 158

		cmp di,3082
		jne loop3
		jne loop3




		   






	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	add sp, 2
	pop bp



	ret 2

	start: 
    call clrscr 
	
	push plus
	push minus
	push star
	call drawtri

 


    mov ah, 0x1        
    int 0x21 

    mov ax, 0x4c00 
    int 0x21 



