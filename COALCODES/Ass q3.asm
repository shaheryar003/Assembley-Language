org 0x100
jmp start
data:dw 9,8,2,1,10,20,30,40
array:dw 9,3,2,6
minimum:db 0
firstsum:db 0
secondsum:db 0
result:db 0
start:
mov bx,0
firsthalf:
mov cx,[data+8]
cmp cx,[data+bx]
je secondhalf
add dx,[data+bx]
add [firstsum],dx
add bx,2
jmp firsthalf
secondhalf:
add ax,[data+bx]
add [secondsum],ax
add bx,2
cmp bx,16
jne secondhalf
Findingmin:
mov bx,0
mov cx,3
outerloop:
mov ax,[array+bx]
mov dx,[array+bx+2]
cmp ax,dx
jb update
mov [minimum],dx
add bx,2
sub cx,1
jnz outerloop
update:
mov [minimum],ax
add bx,2
sub cx,1
jnz outerloop

check:
mov ax,[firstsum]
mov dx,[secondsum]
mov bl,[minimum]
cmp ax,dx
jb smallerax
mov ax,[secondsum]
div bl
mov [result],ax
mov dx,[result]
jmp end
smallerax:
mov ax,[firstsum]
div bl
mov [result],ax
mov dx,[result]

end:
mov ax,0x4c00
int 0x21