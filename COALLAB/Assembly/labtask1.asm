[org 0x01000]

mov ax,0
mov cx,0
mov cx,6

outerloop:


add ax,6

sub cx,1

jnz outerloop


mov ax,0x4c00
int 0x21

