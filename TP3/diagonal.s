.global matrix_diagonal_asm

matrix_diagonal_asm:
    push %ebp      			/* Save old base pointer */
    mov %esp, %ebp 			/* Set ebp to current esp */
    /*esi is row*/
    movl $0, %esi
    /*ebx is col*/
    movl $0, %ebx

    jmp for_loop1

for_loop1:
    /*esi is row*/
    cmpl %esi, 16(%ebp)
    jb end
    /*ebx is col*/
    movl $0, %ebx      # c = 0
    
    
    jmp for_loop2
    
for_loop2:


    /*edi will contain the value of which case is used*/
    
    /*esi is row*/
    movl %esi, %eax /* eax = row */
    movl 16(%ebp), %edi  /* edi = mo  */
    mul %edi        /* eax = mo*r */
    /*ebx is col*/
    addl %ebx, %eax /* eax = mo*r + col*/
    movl $4, %edi
    mul %edi        /* eax = 4(mo*r + col)*/
    

    /*ecx is address of 1st element of inmatrix  */
    movl 8(%ebp), %ecx
    /*edx is address of 1st element of outmatrix */
    movl 12(%ebp), %edx

    /*both addresses are updated 1st + 4(mo*r + c)*/
    addl %eax, %ecx
    addl %eax, %edx

    /*compare ebx (c) and esi (r)*/
    cmpl %esi, %ebx
    jne else
    

    movl (%ecx), %ecx
    movl %ecx, (%edx)

    jmp incr_2


else:
    /*edx contains address of outmatrix*/
    movl $0, %edi
    movl %edi, (%edx)
    jmp incr_2

incr_2:
    addl $1, %ebx
    cmpl %ebx, 16(%ebp)
    jb incr_1

    jmp for_loop2

incr_1:
    addl $1, %esi
    jmp for_loop1


end:        
    addl $8, %esp           # remove local variables from stack
    popl %ebx               # remove reserved register

    leave          /* restore ebp and esp */
    ret            /* return to the caller */