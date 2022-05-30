[org 0x0100]
jmp start
data: dw 8
num1: dw 0,0,0,0,0,0,0,0,0,0,0,0

function:
push word[data]
push bp
mov bp,sp


mov cx,ax
add ax,bx
mov bx,cx

mov [num1+di],ax
add di,1
add dx,1

cmp di,[bp+2]

jz equal
call function

equal:
pop bp
ret 4

start:

mov ax,0
push ax
mov bx,1
push bx
mov di,0
mov dx,0
push dx
call function
mov ax,0x4c00
int 0x21