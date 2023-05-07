include brick.inc
.model small
.stack 100h
;MACROS
makeheart macro coordx20, coordy20
			local lval, coordx20,coordy20,cont

				mov ax, coordx20
				mov dx, coordy20	
				mov cx, 81	
				mov si, 0 		
				mov bx, 0 		

			
				lval:
				PUSH cx

						mov cx,ax 					; moving X co-ordinate in cx for interupt
						sub Heart[bx+si],'0'	; to get a decimal number for color
						mov al, Heart[bx+si]	; array traversing
						mov ah, 0ch       			; interupt to draw pixel
						int 10h
							     
						add Heart[bx+si],'0'
						inc si 						; to get next index	of array
						mov ax,cx					; retrieving value from cx
						inc ax						; increament in coloumn of drawing pixel
						cmp si, 9					; if si is 25 then change row
						jne cont;					; if there is no need to change row

					    mov ax, coordx20				; taking coloumn back to start
						mov si, 0					;
						add bx, 9					; going to next row of array
						inc dx

					;local cont
					cont:
							
				POP cx
				Loop lval
			endm
			newheart macro coordx20, coordy20
			local lval, coordx20,coordy20,cont

				mov ax, coordx20	; X co-ordinate
				mov dx, coordy20	; Y co-ordinate
				mov cx, 81		; size of array = 81
				mov si, 0 		; for indexing
				mov bx, 0 		; for indexing

				;local lval
				lval:
				PUSH cx

						mov cx,ax 					; moving X co-ordinate in cx for interupt
						sub Heart[bx+si],'0'	; to get a decimal number for color
						mov al, 0	; array traversing
						mov ah, 0ch       			; interupt to draw pixel
						int 10h
							     
						add Heart[bx+si],'0'
						inc si 						; to get next index	of array
						mov ax,cx					; retrieving value from cx
						inc ax						; increament in coloumn of drawing pixel
						cmp si, 9					; if si is 25 then change row
						jne cont;					; if there is no need to change row

					    mov ax, coordx20				; taking coloumn back to start
						mov si, 0					;
						add bx, 9					; going to next row of array
						inc dx

					;local cont
					cont:
							
				POP cx
				Loop lval
			endm
.data
buffer db 100 dup("$")
write db "score.txt",0
;read handle
fhandle dw 0
str1 db "File Contents: ",'$'
;write handle
writehandle dw 0
text db "hello",'$'
gameoverpic db 'over.bmp',0
gamewonpic db 'vict.bmp',0
muldispnum dw 0
muldispcount db 0
rem db 0
quo db 0
scoreCount dw 0
scorestr db "Score :  "
highscorestr db "Highscore : "
;heart
heart 	 db '006606600'
			 db '064464460'
			 db '647444446'
			 db '644444446'
			 db '654444456'
			 db '065444560'
			 db '006545600'
			 db '000656000'
			 db '000060000'



        heartxcoord dw 275
			 heartycoord dw 9
       ;x+15
       ;y+0
			 heartxcoord2 dw 290
			 heartycoord2 dw 9
       ;x+15
       ;y+0
			 heartxcoord3 dw 305
			 heartycoord3 dw 9

       lives dw 3
;---------WINDoW_VARS------------
COLLISION_WIDTH dw 310
COLLISION_HEIGHT dw 190
PADDING dw 30
TOP_PADDING dw 10
;--------------------------------
;---------BALL_VARS------------
X_COORD_BALL dw 150
Y_COORD_BALL dw 150
X_VELOCITY_BALL dw 2
Y_VELOCITY_BALL dw 2 
BALL_LEFT dw ?
BALL_RIGHT dw ?

BALL_TOP dw ?
BALL_BOTTOM dw ?

BALL_WIDTH dw 4
BALL_HEIGHT dw 4
;------------------------------
;---------BLOCK_VARS------------
BLOCK brick <10, 30> , <70, 30>, <130, 30>, <190, 30>, <250, 30> ,
            <10, 50> , <70, 50>, <130, 50>, <190, 50>, <250, 50> ,
            <10, 70> , <70, 70>, <130, 70>, <190, 70>, <250, 70>
LENGHT_ dw 50
WIDTH_ dw 14
BLOCK_COL dw 5
num_blocks dw 15
X_COORD_BLOCK_RIGHT dw ?
Y_COORD_BLOCK_RIGHT dw ?
;--------------------------------
;---------PAD_VARS------------
X_COORD_PAD dw 150
Y_COORD_PAD dw 185
PAD_TOP dw 180
X_COORD_PAD_RIGHT dw 214
PAD_LEN dw 64
X_VELOCITY_PAD dw 6
Y_VELOCITY_PAD dw 1
;------------------------------
;---------UTIL_VARS------------
count dw 5
temp dw ?
rect_width dw ?
rect_lenght dw ?
color db 14
collide db "collision",'$'
tempcount dw ?
game_start db 0
lvl_1 db 0
lvl_2 db 0
lvl_3 db 0
note dw 1387
;------------------------------
menu1 db 'menu1.bmp',0
menu2 db 'menu2.bmp',0
menu3 db 'menu3.bmp',0
startpic db 'start.bmp',0
instructionpic db 'instruct.bmp',0
handle_file dw ?
bmp_header db 54 dup (0) ; Contains 54 bytes of data
color_palette db 256*4 dup (0) ; Contains 256 bytes of color each value of color is 4 bytes 
Output_lines db 320 dup (0) ; Our Windows contains 320 rows 
error_prompt db 'Error', 13, 10,'$'
username db "rnd",'$'
scrstr db 3 dup(?)

check db ?
colon db ":",'$'
;================================
.code
;================================
main proc
    mov ax, @data
    mov ds, ax
    call startscr
    call menu
    .IF (game_start == 1)
        call LEVEL_ONE
    .ENDIF

    mov ah,4ch
    int 21h
main endp

display_line macro display_var
  mov dx, offset display_var
  mov ah,09h
  int 21h
endm

convert proc uses ax bx
	mov bl, 10
	.if(scoreCount<10)
		mov ax, scoreCount
		add ax, 48
		mov scrstr[0], al
   mov [check],0
		ret
	.elseif (scoreCount<50)
		mov ax, scoreCount
		div bl
		add al, 48
		add ah, 48
		mov scrstr[0], al
		mov scrstr[1], ah
    mov check,1
		ret
	.endif
ret
convert endp

displayscor proc
mov ah,3dh
mov al,0
mov dx,offset write
int 21H
mov writehandle,ax
mov ah,3fh
mov cx,100
mov dx,offset buffer
mov bx,writehandle
int 21H
mov ah,3eh
mov bx,writehandle
int 21h
mov si,offset buffer
add si,3
mov al,colon[0]
mov [si],al
ret
displayscor endp

highscore proc
call displayscor
	mov cx , LENGTHOF highscorestr
				mov si, offset highscorestr
				mov dl, 11
				
				dispthescore:
					push cx
						
						mov ax , 0
						mov ah,02h
						mov bh,0h
						mov dh, 23    ;setting cursor position for printing 
						int 10h
						
						mov al,[si]
						mov bh, 0h				;page number
						mov bl, 01110000b		;color
						mov cx, 1				;number of times to print character
						mov ah, 09h 			;write character at cursor position
						int 10h
						
						mov ah,02h
						inc dl
						inc si
						int 10h
						
						
					pop cx
				loop dispthescore

        mov dx,offset buffer
        mov ah,09h
        int 21h
ret
highscore endp

writescr proc
mov cx,0
mov dx, 0
mov ah,42h
mov al,2
int 21h
mov ah,3dh
mov al,1
mov dx,offset write
int 21H
mov writehandle,ax
mov cx,0
mov dx, 0
mov ah,42h
mov al,2
int 21h

mov ah,40h
mov bx,writehandle
mov cx,lengthof username
mov dx,offset username
int 21H

mov ah,40h
mov bx,writehandle
call convert
.if(check==0)
mov cx,1
.elseif(check==1)
mov cx,2
.endif
mov dx,offset scrstr
int 21h
mov ah,3eh
mov bx,writehandle
int 21h
ret
writescr endp

blocks_lvl2 proc
    mov di , 0
    mov cx, 15
    L1:
        mov BLOCK[di].color , 5
        mov BLOCK[di].health , 2
        add di , type brick
    LOOP L1
    ret
blocks_lvl2 endp

blocks_lvl3 proc
    mov di , 0
    mov cx, 15
    L1:
        mov BLOCK[di].color , 5
        mov BLOCK[di].health , 3
        .IF (di == 6)
            mov BLOCK[di].health , 128
        .ENDIF
        add di , type brick
    LOOP L1
    ret
blocks_lvl3 endp

scrdisp PROC

				mov cx , LENGTHOF scorestr
				mov si, offset scorestr
				mov dl, 11
				
				dispthescore:
					push cx
						
						mov ax , 0
						mov ah,02h
						mov bh,0h
						mov dh, 1    ;setting cursor position for printing 
						int 10h
						
						mov al,[si]
						mov bh, 0h				;page number
						mov bl, 01110000b		;color
						mov cx, 1				;number of times to print character
						mov ah, 09h 			;write character at cursor position
						int 10h
						
						mov ah,02h
						inc dl
						inc si
						int 10h
						
						
					pop cx
				loop dispthescore
inc scoreCount


        push ax
        mov ax,scoreCount
        mov muldispnum,ax
        pop ax
        call Output

     
				ret
			scrdisp endp

Output Proc
OUTP:
MOV AX,muldispnum
MOV DX,0

HERE:
CMP AX,0
JE DISP

MOV BL,10
DIV BL

MOV DL,AH
MOV DH,0
PUSH DX
MOV CL,AL
MOV CH,0
MOV AX,CX
INC muldispcount
JMP HERE

DISP:
CMP muldispcount,0
JBE EX2
POP DX
ADD DL,48
MOV AH,02H
INT 21H
DEC muldispcount
JMP DISP
Ex2:
ret
Output endp

Beep proc ;plays a beep when the ball lands on the paddle (uses ax) ;taken from gavhim website
	; open speaker
	in al, 61h
	or al, 00000011b
	out 61h, al
	; send control word to change frequency
	mov al, 0B6h
	out 43h, al
	; play frequency 860Hz
	mov ax, [note]
	out 42h, al ; Sending lower byte
	mov al, ah
	out 42h, al ; Sending upper byte
	; wait for any key
    mov cx, 3
	teeeeeeeeet:
	push cx 
	call delayproc
	pop cx 
	loop teeeeeeeeet
	; close the speaker
	in al, 61h
	and al, 11111100b
	out 61h, al
beep endp 

window_collison proc uses ax bx
  mov ax , X_COORD_BALL
  mov bx , Y_COORD_BALL
   cmp ax, TOP_PADDING
    jl REFLECT_X_COORD_BALL
   cmp ax, COLLISION_WIDTH
    jg REFLECT_X_COORD_BALL
  cmp bx, COLLISION_HEIGHT
    jg BALL_LOST
  cmp bx, PADDING
    jl REFLECT_Y_COORD_BALL  
  ret

  REFLECT_X_COORD_BALL:

    NEG X_VELOCITY_BALL
    cmp ax, COLLISION_WIDTH
      jg TOP_RIGHT_CORNER
    cmp ax , PADDING
      jl BOTTOM_LEFT_CORNER
    ret 

  REFLECT_Y_COORD_BALL:
    
    NEG Y_VELOCITY_BALL 
    cmp bx , PADDING
      jl TOP_LEFT_CORNER
    cmp bx, COLLISION_HEIGHT
      jg BOTTOM_RIGHT_CORNER
    ret

  BALL_LOST:
    dec lives
    call dispheart
    call new_ball

    mov cx, 30
      delay:
      push cx 
      call DelayProc
      pop cx
    LOOP delay

    ret
  BOTTOM_RIGHT_CORNER:
    cmp ax , COLLISION_WIDTH
      jl exit
    NEG X_VELOCITY_BALL
    ret
  TOP_RIGHT_CORNER:
    cmp bx , PADDING
      jg exit 
    NEG Y_VELOCITY_BALL
    ret
  TOP_LEFT_CORNER:
    cmp ax , PADDING 
      jg exit
    NEG X_VELOCITY_BALL
    ret 
  BOTTOM_LEFT_CORNER:
    cmp bx, COLLISION_HEIGHT 
      jl exit
    NEG Y_VELOCITY_BALL
    ret
  exit: 
    ret
window_collison endp 

pad_collision proc
  
  mov ax, Y_COORD_BALL
  mov bx , X_COORD_BALL
  .IF (ax > PAD_TOP) && ( bx <= X_COORD_PAD_RIGHT ) && (bx >= X_COORD_PAD) && ( ax < Y_COORD_PAD)
    NEG Y_VELOCITY_BALL
  .ENDIF
  exit:
    ret 
pad_collision endp

ball_coords_x proc

    mov ax , X_COORD_BALL
    mov bx , Y_COORD_BALL

    add ax, BALL_WIDTH
    add ax, X_VELOCITY_BALL
    mov BALL_RIGHT , ax

    mov ax , X_COORD_BALL
    add ax, X_VELOCITY_BALL
    mov BALL_LEFT , ax 

    add bx, BALL_HEIGHT
    mov BALL_BOTTOM , bx

    mov bx, Y_COORD_BALL
    mov BALL_TOP, bx
    ret
ball_coords_x endp

ball_coords_y proc

    mov ax , X_COORD_BALL
    mov bx , Y_COORD_BALL

    add ax, BALL_WIDTH
    mov BALL_RIGHT , ax

    mov ax , X_COORD_BALL
    mov BALL_LEFT , ax 

    add bx, BALL_HEIGHT
    add bx, Y_VELOCITY_BALL
    mov BALL_BOTTOM , bx

    mov bx, Y_COORD_BALL
    add bx, Y_VELOCITY_BALL
    mov BALL_TOP, bx
    ret
ball_coords_y endp

block_coords proc
  mov tempcount, cx
  mov ax , BLOCK[di].xcoord
  mov X_COORD_BLOCK_RIGHT, ax
  mov ax , BLOCK[di].ycoord
  mov Y_COORD_BLOCK_RIGHT, ax
  ADD X_COORD_BLOCK_RIGHT, 50
  ADD Y_COORD_BLOCK_RIGHT, 15
  ret
block_coords endp

get_coords proc
  mov ax , BALL_LEFT
  mov bx , BALL_RIGHT
  mov cx , BALL_BOTTOM
  mov dx , BALL_TOP
  ret
get_coords endp 

bounce_back proc
  call ball_coords_x
  call get_coords
  .IF (ax < X_COORD_BLOCK_RIGHT) && (bx > BLOCK[di].xcoord) && (cx > BLOCK[di].ycoord) && (dx < Y_COORD_BLOCK_RIGHT)
    NEG X_VELOCITY_BALL
    mov [note], 0e1fh 
    call beep
    call ball_collided
    call scrdisp
  .ENDIF
  call ball_coords_y
  call get_coords
  .IF (ax < X_COORD_BLOCK_RIGHT) && (bx > BLOCK[di].xcoord) && (cx > BLOCK[di].ycoord) && (dx < Y_COORD_BLOCK_RIGHT)
    NEG Y_VELOCITY_BALL
    mov [note], 0e1fh 
    call beep
    call ball_collided
    call scrdisp
  .ENDIF
  ret
bounce_back endp

ball_collided proc
    dec BLOCK[di].health
    mov BLOCK[di].color , 13
    mov cx, BLOCK[di].xcoord
    mov dx, BLOCK[di].ycoord
    call new_block
    .IF (BLOCK[di].health <= 0)
        call block_destroyed
    .ENDIF
    ret
ball_collided endp

block_collision proc
  mov di , 0
  mov cx,15
  L1:
  call block_coords
  call bounce_back
  add di , type brick
  mov cx, tempcount
  LOOP L1
  ret
block_collision endp

block_destroyed proc
    mov BLOCK[di].color, 0
    mov cx, BLOCK[di].xcoord
    mov dx, BLOCK[di].ycoord
    call new_block
    NEG BLOCK[di].xcoord
    NEG BLOCK[di].ycoord
    dec num_blocks
    ret
block_destroyed endp

move_ball proc
  L1:
    call remove_ball
    mov ax, X_VELOCITY_BALL    ; Moving the current ball by add X_COORD_BALL and X_VELOCITY_BALL which gives us the new X_COORD_BALL
    add X_COORD_BALL, ax
    mov ax , X_COORD_BALL

    mov ax, Y_VELOCITY_BALL
    add Y_COORD_BALL, ax  ; Moving the current ball by add Y_COORD_BALL and Y_VELOCITY_BALL which gives us the new Y_COORD_BALL
    call window_collison 
    call pad_collision 
    call redraw_ball
       mov cx, 2
      L2:
        push cx
        call DelayProc
        pop cx
      LOOP L2
   
  ret
move_ball endp 

move_pad proc uses ax 
  mov ax, 0
  call draw_pad

  mov ah,01h
  int 16h
  jz exit

  mov ah, 00h 
  int 16h 

  ; ONCE WE FIND THE KEY WHICH WAS PRESSED NOW WE JUST WANT TO JUMP TO THE APPRORIATE KEY PRESS CONDITION
  cmp ah,1BH
  je pause_scr
  cmp ah, 4Bh
  je left_key
  cmp ah, 4Dh
  je right_key
  cmp ah, 1
  je return 


  pause_scr:
    call menu
    call draw_block

  ; THIS IS THE LEFT KEY PRESS FOR OUR PAD MOVEMENT 

  left_key:
    mov ax , TOP_PADDING ; MAKING SURE OUR PAD IS NOT OUT OF OUR BOUNDS
    cmp X_COORD_PAD, ax
    jl exit
    ; ONCE WE MAKE SURE THAT OUR PAD IS WITHIN BOUNDS 
    ; WE UPDATE ITS LOCATION BY PAINTING THE PREV PAD TO BE BLACK AND MAKE A NEW PAD AFTER 
    ; ADDING THE PAD VELOCITY TO THE PAD 
    mov color, 0 
    call draw_pad
    mov ax , X_VELOCITY_PAD
    sub X_COORD_PAD, ax
    sub X_COORD_PAD_RIGHT, ax
    mov color, 14
    call draw_pad
  jmp exit

  right_key:
    mov ax , COLLISION_WIDTH
    cmp X_COORD_PAD_RIGHT, ax ; MAKING SURE OUR PAD IS NOT OUT OF OUR BOUNDS
    jg exit
    ; ONCE WE MAKE SURE THAT OUR PAD IS WITHIN BOUNDS 
    ; WE UPDATE ITS LOCATION BY PAINTING THE PREV PAD TO BE BLACK AND MAKE A NEW PAD AFTER 
    ; ADDING THE PAD VELOCITY TO THE PAD 
    mov color, 0
    call draw_pad
    mov ax , X_VELOCITY_PAD
    add X_COORD_PAD, ax
    add X_COORD_PAD_RIGHT, ax
    mov color, 14
    call draw_pad
  jmp exit

  exit:
    ret
   return:
    call return_to_text_mode
    call return_to_dos  
move_pad endp 

filled_square proc
  mov temp , cx
  L3:
  mov cx, temp
  mov si, rect_lenght
  L4:
  mov ah, 0ch
  mov al, color
  mov bh, 0
  int 10h
  inc cx
  dec si
  cmp si, 0
  je L1
  jmp L4
  L1:	
  cmp rect_width, 0
  je L2
  dec rect_width
  inc dx
  jmp L3
  L2:
  ret
filled_square endp

draw_pad proc
  mov cx, X_COORD_PAD
  mov dx, Y_COORD_PAD
  mov ax , PAD_LEN
  mov rect_lenght, ax
  mov rect_width, 5 
  call filled_square
  ret
draw_pad endp
  
draw_block proc
    mov di , 0
    mov cx, 15
    mov tempcount, cx 
    L1:
    mov tempcount , cx
    mov cx, BLOCK[di].xcoord
    mov dx,BLOCK[di].ycoord
    mov rect_lenght, 50
    mov rect_width , 15 
    mov al , BLOCK[di].color
    mov color , al
    call filled_square
    mov cx, tempcount
    add di , type brick
    LOOP L1
    ret
draw_block endp

redraw_blocks proc
    mov di , 0
    mov cx, 15
    L1:
        NEG BLOCK[di].xcoord
        NEG BLOCK[di].ycoord
        mov BLOCK[di].color , 5
        mov BLOCK[di].health , 2
        add di , type brick
    LOOP L1
    ret
redraw_blocks endp

destroy_block proc
    mov rect_width , 15
    mov rect_lenght , 50
    mov color , 0
    call filled_square
    ret
destroy_block endp

new_block proc 
    mov rect_width , 15
    mov rect_lenght , 50
    mov al , BLOCK[di].color
    mov color , al
    call filled_square
    ret
new_block endp 

remove_ball proc
  mov color, 00         ;Here the color of the previous ball is being changed to black so its not visible anymore
  call display_ball
  ret
remove_ball endp

redraw_ball proc
  mov color ,14 
  call display_ball     ; Redrae the ball in the current position and make the new ball visible by changing color to yellow 
  ret
redraw_ball endp 

new_ball proc
  mov X_COORD_BALL, 150
  mov Y_COORD_BALL, 100
  mov X_VELOCITY_BALL, 2
  mov X_VELOCITY_BALL, 2
  call display_ball
  mov cx, 20
  L1:
    push cx
    call DelayProc
    pop cx
  LOOP L1 

  ret
new_ball endp 

display_ball proc
    mov rect_width, 4
    mov rect_lenght, 4
    mov cx, X_COORD_BALL
    mov dx, Y_COORD_BALL
    call filled_square
    ret
display_ball endp 

set_video_mode proc 
    mov ah , 00h
    mov al, 13h
    int 10h
    ret
set_video_mode endp 

return_to_dos proc
    mov ah, 4ch 
    int 21h
    ret
return_to_dos endp

get_ch proc
    mov ah , 00h 
    int 16h  
    ret
get_ch endp

return_to_text_mode proc 
    mov ah, 0
    mov al, 2
    int 10h
    ret
return_to_text_mode endp 

DelayProc proc 
  mov cx,1 
  mov dx,3dah
  loop3:
    push cx
    l1:
      in al,dx
      and al,08h
      jnz l1
    l2:
      in al,dx
      and al,08h
      jz l2
   pop cx
   loop loop3
  ret
DelayProc endp

testdisphearts proc
drawThreehearts:
										makeheart heartxcoord,heartycoord
										makeheart heartxcoord2,heartycoord2
										makeheart heartxcoord3,heartycoord3
ret
testdisphearts endp

dispheart proc
.if(lives==3)
                  drawThreehearts:
										makeheart heartxcoord,heartycoord
										makeheart heartxcoord2,heartycoord2
										makeheart heartxcoord3,heartycoord3
									
.elseif(lives==2)
									drawTwohearts:
										newheart heartxcoord3,heartycoord3
										makeheart heartxcoord,heartycoord
										makeheart heartxcoord2,heartycoord2
								
.elseif(lives==1)
									drawOne:
										newheart heartxcoord3,heartycoord3
										newheart heartxcoord2,heartycoord2
										makeheart heartxcoord,heartycoord
.else
gameover:
call writescr
mov dx,offset gameoverpic
call display
call get_ch
call return_to_text_mode
call return_to_dos
.ENDIF
ret
dispheart endp


LEVEL_ONE proc 


  call dispheart
  call draw_block
  L1:
    call move_ball
    call move_pad
    call block_collision
    .IF (num_blocks <= 0)
        mov lvl_1 , 1
        mov dx,offset gamewonpic
        call display
        call get_ch
        call LEVEL_TWO

        ret
    .ENDIF
  jmp L1
LEVEL_ONE endp 

LEVEL_TWO proc
    call set_video_mode
    mov lives , 3
    .IF (lvl_1 == 0)
        call blocks_lvl2
    .ELSE
        call redraw_blocks
    .ENDIF
    call draw_block
    call new_ball 
    mov X_VELOCITY_BALL,3
    mov Y_VELOCITY_BALL,3
    inc X_VELOCITY_PAD
    sub X_COORD_PAD_RIGHT, 24
    sub PAD_LEN, 24
    mov num_blocks, 15
    L1:
    call move_ball
    call move_pad
    call block_collision
    .IF (num_blocks <= 0)
        mov lvl_2, 1
         mov dx,offset gamewonpic
        call display
        call get_ch
        CALL LEVEL_THREE

        ret

    .ENDIF
    jmp L1

LEVEL_TWO endp

LEVEL_THREE proc
    mov lvl_3 , 1
    call set_video_mode
    mov lives , 3
    .IF (lvl_2 == 0)
        call blocks_lvl3
        inc Y_VELOCITY_BALL
        inc X_VELOCITY_BALL
        sub X_COORD_PAD_RIGHT, 24
        sub PAD_LEN, 24
    .ELSE
        call redraw_blocks
        call blocks_lvl3
    .ENDIF
    call draw_block
    call new_ball
    mov X_VELOCITY_BALL,4
    mov Y_VELOCITY_BALL, 4
    inc X_VELOCITY_PAD
    inc X_VELOCITY_PAD
    mov num_blocks, 15
    L1: 
    call move_ball
    call move_pad
    call block_collision
    .IF (num_blocks <= 0)
      mov dx,offset gamewonpic
      call display
      call get_ch
        ret
    .ENDIF
    jmp L1


LEVEL_THREE endp

startscr proc
  mov ax, 13h
    int 10h
    mov dx, offset startpic
    call display
    mov ah,02H
    mov bx,0
    mov dh,21
    mov dl,6
    int 10h
    ;mov dx,offset username
    ;mov ah,3fh
    ;int 21h
    mov di,offset username
    mov ah,01h
    int 21h
    mov [di],al
    inc di
    mov ah,01h
    int 21h
    mov [di],al
    inc di
    mov ah,01h
    int 21h
    mov [di],al
    ;mov bl,ah
    ;mov ah,09h
    ;mov al,'A'
    ;mov cx,1
    ;int 21h
    mov ah,10h
    int 16h

    ret
startscr endp

menu proc

    print:
    mov dx,offset menu1
    call display
    call highscore

    same:
    mov ah,10h
    int 16h

    cmp ah,1Ch
    jne notenter1
    jmp startgame
    notenter1:
    cmp ah,3Bh
    jne notexit
    jmp exitt
    notexit:
    cmp ah,50h
    jne same
    mov dx,offset menu2
    call display
    call highscore
    same2:
    mov ah,10h
    int 16h

    cmp ah,1Ch
    jne notenter2
    jmp instructions
    notenter2:
    cmp ah,3Bh
    jne notexit2
    jmp exitt
    notexit2:
    cmp ah,50h
    jne same2
    mov dx,offset menu3
    call display
    call highscore


    same3:
    mov ah,10h
    int 16h

    cmp ah,1Ch
    jne notenter3
    jmp quit
    notenter3:
    cmp ah,3Bh
    jne notexit3
    jmp exitt
    notexit3:
    cmp ah,50h
    jne same3
    mov dx,offset menu3
    call display
    loop print


    startgame:
        mov game_start, 1
        call set_video_mode
        ret
    jmp exitt

    instructions:
    mov dx, offset instructionpic
    call display
    mov ah,10h
    int 16h
    jmp print

    quit:
    jmp exitt

    exitt:
      call return_to_text_mode
      call return_to_dos
    ret
menu endp

fileend PROC
  mov  ah, 3Eh
  mov  bx, [handle_file]
  int  21h
  ret
 fileend endp
;================================
display proc
    ;================================

    ; Graphic mode
    mov ax, 13h
    int 10h

    ; Process BMP file
  
     ; Open file
    mov ah, 3Dh
    xor al, al
    int 21h
    jc cant_open
    mov [handle_file], ax
    jmp skip
    cant_open:
    mov dx, offset error_prompt
    mov ah, 9h
    int 21h

    ; Read BMP file bmp_header, 54 bytes
    skip:
    mov ah,3fh
    mov bx, [handle_file]
    mov cx,54
    mov dx,offset bmp_header
    int 21h


     ; Read BMP file color color_palette, 256 colors * 4 bytes (400h)
    mov ah,3fh
    mov cx,400h
    mov dx,offset color_palette
    int 21h

  ; Copy the colors color_palette to the video memory
    ; The number of the first color should be sent to port 3C8h
    ; The color_palette is sent to port 3C9h
    
    mov si,offset color_palette
    mov cx,256
    mov dx,3C8h
    mov al,0

    ; Copy starting color to port 3C8h

    out dx,al

    ; Copy color_palette itself to port 3C9h

    inc dx
    Get_Pal:

    ; Note: Colors in a BMP file are saved as BGR values rather than RGB.

    mov al,[si+2] ; Get red value.
    shr al,1
    shr al,1     ; Max. is 255, but video color_palette maximal

    ; value is 63. Therefore dividing by 4.

    out dx,al ; Send it.
    mov al,[si+1] ; Get green value.
    shr al,1
    shr al,1    
    out dx,al ; Send it.
    mov al,[si] ; Get blue value.
    shr al,1
    shr al,1    
    out dx,al ; Send it.
    add si,4 ; Point to next color.

    ; (There is a null chr. after every color.)

    loop Get_Pal

   
    ; BMP graphics are saved upside-down.
    ; Read the graphic line by line (200 lines in VGA format),
    ; displaying the lines from bottom to top.

    mov ax, 0A000h
    mov es, ax
    mov cx,200
    PrintBMPLoop:
    push cx

    ; di = cx*320, point to the correct screen line

    mov di,cx
    shl cx,1
    shl cx,1
    shl cx,1
    shl cx,1
    shl cx,1
    shl cx,1

    shl di,1
    shl di,1
    shl di,1
    shl di,1
    shl di,1
    shl di,1
    shl di,1
    shl di,1

    add di,cx

    ; Read one line

    mov ah,3fh
    mov cx,320
    mov dx,offset Output_lines
    int 21h

    ; Copy one line into video memory

    cld 

    ; Clear direction flag, for movsb

    mov cx,320
    mov si,offset Output_lines
    rep movsb 

    ; Copy line to the screen
    ;rep movsb is same as the following code:
    ;mov es:di, ds:si
    ;inc si
    ;inc di
    ;dec cx
    ;loop until cx=0

    pop cx
    loop PrintBMPLoop
    call fileend
    ret
    
    ;================================
display endp

end