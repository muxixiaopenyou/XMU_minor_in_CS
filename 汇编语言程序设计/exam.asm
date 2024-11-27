;score_list
;考试的时候写的，比较混乱，整体思路大概就是转成二进制存储、插入排序、再转成十进制输出
datarea segment
    score dw 100 dup('$')
    num dw 0
datarea ends
;***************************
prognam segment
;---------------------------
main proc far
    assume cs:prognam,ds:datarea
start:
    push ds
    sub ax,ax
    push ax

    mov ax,datarea
    mov ds,ax

    mov si,0

;大循环
a1:
    call get_input

    ;如果当前只有一个数字，直接插入
    mov di,0
    cmp num,1
    je first_insert
    
    ;如果不止一个数字，找到位置降序排序
find_position:
    ;当前数据小于bx，插入
    cmp score[di],bx
    jle next_insert

    ;否则di+2，查找下一个位置
    add di,2
    ;比较di si，如果是最后一个位置直接插入
    cmp di,si
    jne find_position
    mov score[di],bx

next_insert:
;循环后移
    mov ax,bx
loop_insert:
    ;已经是最后一个数据，直接插入si位置
    cmp di, si
    je last
    jmp not_last

last:
    mov score[di],ax
    je input_end

not_last:
    ;把当前数据存到ax中，交换ax和score[di]
    xchg ax,score[di]
    add di,2
    jmp loop_insert

first_insert:
    mov score[di],bx
    jmp input_end

input_end:
    mov di,0
    mov cx,num
output_loop:
    ;排序结束，输出
    mov bx,score[di]
    push cx
    call output
    pop cx
    add di,2
    loop output_loop
    call crlf
    jmp a1

main endp
;------------------------------
get_input proc near ;接收一个十进制数转成二进制存入bx
    mov bx,0
newchar:
    mov ah,1
    int 21h
    sub al,30h
    jl exit
    cmp al,9
    jg exit
    cbw

    xchg ax,bx
    mov cx,10
    mul cx
    xchg ax,bx
    add bx,ax

    jmp newchar

exit:
    inc num
    add si,2 ;si始终指向数据后一个位置
    ret
get_input endp
;-----------------------------------
output proc near ;bx中的二进制数以十进制显示
    mov cx,10d
    call dec_div
    mov cx,1d
    call dec_div
    ret
output endp
;----------------------------------
dec_div proc near
    mov ax,bx
    mov dx,0
    div cx
    mov bx,dx
    mov dl,al
    add dl,30h
    mov ah,2
    int 21h
    ret
dec_div endp
;-----------------------------------
crlf proc near
    mov dl,0dh
    mov ah,02h
    int 21h
    mov dl,0ah
    mov ah,02h
    int 21h
ret
crlf endp
;------------------------------------
prognam ends
;************************************
    end start