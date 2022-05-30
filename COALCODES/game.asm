.model large


.data

exit db 0
player_position dw 1760d                         ;position of player
arrow_position dw 0d                             ;position of arrow
arrow_status db 0d                          ;0 = arrow ready to go else not 
arrow_limit dw  150d     ;150d 
enemy_position dw 3000d     ;3990d
enemy_status db 0d                                           ;direction of play                                        ;up=8, down=2
direction db 0d
buf db '00:0:0:0:0:0:00:00$'          ;score veriable
hit_num db 0d
hits dw 0d
miss dw 0d  
game_over dw '  ',0ah,0dh
dw '                                             ',0ah,0dh
dw '                                             ',0ah,0dh
dw '                              ^   Score   ^  ',0ah,0dh
dw '                               --------------',0ah,0dh
dw ' ',0ah,0dh 
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                                Game Over!!!!',0ah,0dh
dw '                        Press Enter to start again.$',0ah,0dh 


game_start dw '  ',0ah,0dh

dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw ' ',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '               ||                                                  ||',0ah,0dh                                        
dw '               ||                Air Fighter                       ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh          
dw '               ||     Use up and down key to move player           ||',0ah,0dh
dw '               ||          and space button to shoot               ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '               ||            Press Enter to start                  ||',0ah,0dh 
dw '               ||                                                  ||',0ah,0dh
dw '               ||                                                  ||',0ah,0dh
dw '                ====================================================',0ah,0dh
dw '$',0ah,0dh




.code 

main proc
mov ax,@data
mov ds,ax

mov ax, 0B800h
mov es,ax 
jmp game_menu                              ;display main menu
                                                                 
main_loop:                                 ;update logic and display everything                                       ;check any key is pressed
    mov ah,1h
    int 16h                                ;go if pressed
    jnz key_press
    jmp l1                        ;or just continue
    
    l1:                           ;checking every thing
        cmp miss,9                         ;if baloon miss 9 times.go to game over section
        jge gameover
        
        mov dx, arrow_position                   ;checking collitions
        cmp dx, enemy_position
        je hit
        
        cmp direction,8d                   ;update player position
        je  up
        cmp direction,2d                   ;up or down based on direction veriable
        je down
        
        mov dx,arrow_limit                 ;hide arrow 
        cmp arrow_position, dx
        jge arrow_hide
        
        cmp enemy_position, 0d                   ;check missed enemy
        jle enemy_miss
        jne enemy1 
    
        hit:                               ;play sound if hit
            mov ah,2
            mov dx, 7d
            int 21h 
            
            inc hits                       ;update score
            
            lea bx,buf               ;display score
            call score 
            lea dx,buf
            mov ah,09h
            int 21h
            
            mov ah,2                       ;new line
            mov dl, 0dh
            int 21h    
            
            jmp fire_enemy                  ;new enemy pops up
    
        enemy1:                       ;draw enemy
            mov cl, ' '                    ;hide old enemy
            mov ch, 1000b
        
            mov bx,enemy_position 
            mov es:[bx], cx
                
            sub enemy_position,160d              ;and draw new one in new position
            mov cl, 124d
            mov ch, 1000b
        
            mov bx,enemy_position 
            mov es:[bx], cx
            
            cmp arrow_status,1d            ;check any arrow to rander
            je arrow1
            jne l2 
        
        arrow1:                      ;render arrow
        
            mov cl, ' '
            mov ch, 1111b
        
            mov bx,arrow_position               ;hide old position
            mov es:[bx], cx
                
            add arrow_position,10d               ;draw new position
            mov cl, 26d
            mov ch, 1001b
        
            mov bx,arrow_position 
            mov es:[bx], cx
        
        l2:
            
            mov cl, 125d                  ;draw player 
            mov ch, 1100b
            
            mov bx,player_position 
            mov es:[bx], cx
            
             
                       
    cmp exit,0
    je main_loop                          ;end main enemy
    jmp exit_game
 
jmp l2
    
up:                                ;hide player old position
    mov cl, ' '
    mov ch, 1111b
        
    mov bx,player_position 
    mov es:[bx], cx
    
    sub player_position, 160d                  ;set new postion of player
    mov direction, 0    

    jmp l2                      ;it will draw in main loop
    
down:
    mov cl, ' '                           ;same as player up
    mov ch, 1111b                         ;hide old one and set new postion
                                          
    mov bx,player_position 
    mov es:[bx], cx
    
    add player_position,160d                   ;and main loop draw that
    mov direction, 0
    
    jmp l2

key_press:                              ;input hanaling section
    mov ah,0
    int 16h

    cmp ah,48h                            ;go upKey if up button is pressed
    je upKey
    
    cmp ah, 50h
    je downKey
    
    cmp ah,39h                            ;go spaceKey if up button is pressed
    je spaceKey
    
    cmp ah,4Bh                            ;go leftKey (this is for debuging)
    je leftKey
     
                                          ;if no key is pressed go to inside of loop
    jmp l1

leftKey:                                  ;we use it for debuging 
    ;jmp game_over
    inc miss        
    lea bx,buf
    call score 
    lea dx,buf
    mov ah,09h
    int 21h
    
    mov ah,2
    mov dl, 0dh
    int 21h
jmp l1
    
upKey:                                    ;set player direction to up
    mov direction, 8d
    jmp l1

downKey:
    mov direction, 2d                     ;set player direction to down
    jmp l1
    
spaceKey:                                 ;shoot a arrow
    cmp arrow_status,0
    je  fire_arrow
    jmp l1

fire_arrow:                               ;set arrow postion in player position
    mov dx, player_position                    ;so arrow fire from player postion
    mov arrow_position, dx
    
    mov dx,player_position                     ;when fire an arrow it also set limit
    mov arrow_limit, dx                   ;of arrow. where it should be hide
    add arrow_limit, 150d  ;150
    
    mov arrow_status, 1d                  ;set arrow status.It prevents multiple 
    jmp l1                       ;shooting 

enemy_miss:
    add miss,1                            ;update score

    lea bx,buf                      ;display score
    call score 
    lea dx,buf
    mov ah,09h
    int 21h
                                          ;new line
    mov ah,2
    mov dl, 0dh
    int 21h
jmp fire_enemy
    
fire_enemy:                                ;fire new enemy
    mov enemy_status, 1d
    mov enemy_position, 3000d     ;3990d
    jmp enemy1
    
arrow_hide:
    mov arrow_status, 0                   ;hide arrow
    
    mov cl, ' '
    mov ch, 1111b
    
    mov bx,arrow_position 
    mov es:[bx], cx
    
    cmp enemy_position, 0d 
    jle enemy_miss
    jne enemy1 
    
    jmp l2
                                          ;print game over screen
gameover:
    mov ah,09h
    ;mov dh,0
    mov dx, offset game_over
    int 21h
    
    
    
    mov cl, ' '                           ;hide last of screen enemy
    mov ch, 1111b 
    mov bx,arrow_position                      
    
    mov cl, ' '                           ;hide player
    mov ch, 1111b 
    mov bx,player_position  
 
    
    ;reset value                          ;update veriable for start again
    mov miss, 0d
    mov hits,0d
    
    mov player_position, 1760d

    mov arrow_position, 0d
    mov arrow_status, 0d 
    mov arrow_limit, 150d      ;150d

    mov enemy_position, 3000d       ;3990d
    mov enemy_status, 0d
         
    mov direction, 0d
                                           ;wait for input
    input:
        mov ah,1
        int 21h
        cmp al,13d
        jne input
        call clear
        jmp main_loop
    

game_menu:
                                           ;game menu screen
    mov ah,09h
    mov dh,0
    mov dx, offset game_start
    int 21h
                                           ;wait for input
    input2:
        mov ah,1
        int 21h
        cmp al,13d
        jne input2
        call clear
        
        lea bx,buf                   ;display score
        call score 
        lea dx,buf
        mov ah,09h
        int 21h
    
        mov ah,2
        mov dl, 0dh
        int 21h
        
        jmp main_loop

exit_game:                                  ;end of our sweet game :)
mov exit,10d

main endp

proc score
    lea bx,buf
    
    mov dx, hits
    add dx,48d 
    
    mov [bx], 9d
    mov [bx+1], 9d
    mov [bx+2], 9d
    mov [bx+3], 9d
    mov [bx+4], 'H'
    mov [bx+5], 'i'                                        
    mov [bx+6], 't'
    mov [bx+7], 's'
    mov [bx+8], ':'
    mov [bx+9], dx
    
    mov dx, miss
    add dx,48d
    mov [bx+10], ' '
    mov [bx+11], 'M'
    mov [bx+12], 'i'
    mov [bx+13], 's'
    mov [bx+14], 's'
    mov [bx+15], ':'
    mov [bx+16], dx
ret    
score endp 

clear proc near
        mov ah,0
        mov al,3
        int 10h        
        ret
clear endp

end main



