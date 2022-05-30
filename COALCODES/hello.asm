[org 0x0100]

jmp start

array:dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0



Fib:
	
	push bp
	mov bp, sp
	
	push dx



	mov dx, [bp+4] ; Number to calculate fibnocci series


	cmp dx, 0
	je zero

	cmp dx, 1
	je zerOne


	cmp di, dx
	je exit

	cmp di, 2
	jne l1

	mov word[bx+0], 0
	mov word[bx+2], 1





	l1:


		add di,1
		mov ax, [bx+si-2]
		mov cx, [bx+si]

		add ax, cx

		add si, 2


		mov [bx+si], ax

		cmp di , dx

		je exit

		push word[bp+4]

		call Fib


		pop dx
		pop bp

		ret 2




	zero:
		mov word[bx+si], 0
		jmp exit


	zerOne:
		mov word[bx+si],0
		mov word[bx+2], 1

		jmp exit



	exit:

		pop dx
		pop bp

		ret 2


start:
	
	push 15

	mov bx, array


	mov ax, 0

	mov cx ,0

	mov si, 2

	mov di, 2

	call Fib


	mov ax, 0x4c00
	int 0x21