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
    cmpl %esi, 8(%ebp)
    ja fin
    # init ebx (colomn)
    movl $0, %ebx
    jmp boucle_2

boucle_2:
    # compare colomn to 8(%ebp), go to boucle if above
    cmpl %ebx, 8(%ebp)
    # go back to the 1st loop
    ja incr

    # check if the two matrices are equal at index
    # in: ebp - 8 - 4(cIndex + 10*rIndex)
    # store this in ecx
    # ecx = 10
    movl $10, %ecx
    # eax = esi (row)
    movl %esi, %eax
    # eax = 10*row
    mul %ecx
    # eax = 10*row + colomn
    addl %ebx, %eax
    # ecx = 4
    movl $4, %ecx
    # eax = 4(10*row + colomn)
    mul %ecx
    # ecx contains ebp
    movl %ebp, %ecx
    # ecx = ebp - 8
    subl $8, %ecx
    # ecx = ebp - 8 - 4(10*row + colomn)
    subl %eax, %ecx

    # out: ebp - 8 - 4(cIndex - 10*rIndex - nbElements
    # edx = 10
    movl $10, %edx
    # eax = esi (row)
    movl %esi, %eax
    # eax = 10*row
    mul %edx
    # eax = 10*row + colomn
    addl %ebx, %eax
    # eax = 10*row + colomn + nbElements
    addl -4(%ebp), %eax
    # edx = 4
    movl $4, %edx
    # eax = 4(10*row + colomn + nbElements)
    mul %edx
    # edx contains ebp
    movl %ebp, %edx
    # edx = ebp - 8
    subl $8, %edx
    # edx = ebp - 8 - 4(10*row + colomn + nbElements)
    subl %eax, %edx

    # addresses pushed on the stack
    push %ecx
    push %edx
    # values pushed on the stack
    push (%ecx)
    push (%edx)

    movl (%ecx), %ecx
    movl (%edx), %edx

    cmpl %ecx, %edx
    jne else

    # addresses back 
    movl -8(%ebp), %ecx
    movl -12(%ebp), %edx



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