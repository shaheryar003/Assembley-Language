org 0x100


mov ax,-10
mov bx,-100

cmp ax,bx

jg high




mov ax,0x4c00
int 0x21

high:
mov dx,ax

mov ax,0x4c00
int 0x21