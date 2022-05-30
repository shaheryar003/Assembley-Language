[org 0x0100]


jmp start
num: dw 4
start:
mov ax,[num]
push ax
push cx
call facto
mov ax,0x4c00
int 0x21


facto:
push bp
mov bp,sp
mov ax,[bp+6]
mov cx,ax
dec cx
fact:
mul cx
loop fact
pop bp
ret 4




