.global matrix_diagonal_asm

matrix_diagonal_asm:
    push %ebp      			/* Save old base pointer */
    mov %esp, %ebp 			/* Set ebp to current esp */
    
    mov 8(%ebp), %eax
    mul %eax

    # valeur de nb element stocker sur -4(ebp)
    push %eax
    
    # esi will be row
    mov $0, %esi
    # ebx will be colomn
    mov $0, %ebx
    
    jmp boucle



boucle:
    # compare row (esi) with 8(%ebp), end if above
    cmpl %esi, 8(%ebp)    
    ja fin
    
    # jump to second for loop
    # reset esi to 0
    movl $0, %esi
    jmp boucle_2

    jmp incr

boucle_2:
    # compare colomn to 8(%ebp), go to boucle if above
    cmpl %ebx, 8(%ebp)
    ja boucle

    movl -8(%ebp), %edx
    movl %edx, %eax
    mul $4
    movl %eax, %edx    



    # use eax to hold value 10
    movl $10, %eax
    # eax is now multiplied by esi
    mul %esi
    # ebx holds value of row, so add it to eax
    add %ebx, %eax
    # compare the values of the 2 matrices
    # order in the stack, top down:
    # ebp, out matrix, in matrix, nb elements = -4 ebp
    # 4 + 4*eax and 4 + 4(eax + nbELement), stock this value in edx

    addl %eax, %edx

    movl 4(%eax), %ecx
    cmpl %ecx, 0(,%edx,1)
    jne else

    movl (%edx), %ecx
    movl %ecx, 4(,%eax,4)
    
    jmp incr_2


else:
    # do something
    movl $0, 4(,%eax,4)
    jmp incr_2

incr:
    # esi is row, so add 1 to row
    addl $1, %esi     
    jmp boucle

incr_2:
    # ebx is col, so add 1 to col
    addl $1, %ebx
    jmp boucle_2


fin:
    leave
    ret