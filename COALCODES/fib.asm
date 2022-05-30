[org 0x100]
jmp start
fibu: dw 0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0		
num: dw 15
start:
mov bx,fibu
push bx
mov di,[num]
push di
mov si,6
mov cx,3
call series
mov ax,0x4c00
int 0x21



series:
push bp
mov bp,sp
mov bx,[bp+6]

check:
cmp cx,[bp+4]
je return

mov ax,[bx+si-4]
mov dx,[bx+si-2]
add ax,dx
mov [bx+si],ax
add cx,1
add si,2
push bx
push di
call series

return:
pop bp
ret 4
