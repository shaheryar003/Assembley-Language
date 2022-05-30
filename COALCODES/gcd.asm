[org 0x0100]
jmp start
num1 : dw 20
num2: dw 15

gcd:
push bp
mov bp,sp
mov ax,[bp+6]
mov bx,[bp+4]

cmp bx,0
jz return

cmp ax,bx
jb less
sub ax,bx
push ax
push bx
call gcd
pop bp
ret 4
less:
push bx
push ax
call gcd
return:
pop bp
ret 4

start:
push word[num1]
push word[num2]
call gcd
mov ax,0x4c00
int 0x21

