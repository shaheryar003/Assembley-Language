org 0x100
jmp start
data:dW 1,2,3,4
evennum:db 0
oddnum:db 0
start:
mov bx,0
mov cx,4
mov si,2
jmp outerloop

even:
mov ax,1
add bx,2
add [evennum],ax
sub cx,1
jnz outerloop
jmp changing
outerloop:
mov ax,[data+bx]
div si
cmp ah,0
je even
odd:
mov ax,1
add bx,2
add [oddnum],ax
sub cx,1
jnz outerloop
changing:
mov dl,[oddnum]
mov dh,[evennum]

mov ax,0x4c00
int 0x21