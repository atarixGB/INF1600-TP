.global matrix_multiply_asm

matrix_multiply_asm:
    push %ebp      /* save old base pointer */
    mov %esp, %ebp /* set ebp to current esp */
    /* Write your solution here */

    /* esi is r */
    movl $0, %esi
    /* edi is c */
    movl $0, %edi
    /* ebx is i */
    movl $0, %ebx
    jmp for_loop_1

for_loop_1:
    cmpl %esi, 20(%ebp)
    jb end
    movl $0, %edi
    jmp for_loop_2 

for_loop_2:
    movl $0, %ebx

    movl $0, %eax
    pushl %eax
    
    jmp for_loop_3


for_loop_3:
    /*i is ebx*/
    /*r is esi*/
    /*c is edi*/

    /*inmatdata1[i + r * matorder]*/
    
    movl %esi, %eax     /*eax = r*/
    movl 20(%ebp), %ecx /*ecx = mo*/
    mul %ecx            /*eax = r*mo*/
    addl %ebx, %eax     /*eax = i + r*mo*/
    movl $4, %ecx       /*ecx = 4*/
    mul %ecx            /*eax = 4(i + r*mo)*/
    movl 8(%ebp), %edx  /*edx = adress of in1*/
    addl %eax, %edx     /*edx = add_in1 + 4(i + r*mo) */
    push %edx    

    /* inmatdata2[c + i * matorder]*/
    movl %ebx, %eax     /*eax = i*/
    movl 20(%ebp), %ecx /*ecx = mo*/
    mul %ecx            /*ecx = i*mo*/
    addl %edi, %eax     /*eax = c + i*mo*/
    movl $4, %ecx       /*ecx = 4*/
    mul %ecx            /*eax = 4(c + i*mo)*/
    movl 12(%ebp), %ecx /*ecx = address of in2*/
    addl %eax, %ecx     /*ecx = add_in2 + 4(c + i*mo) */

    popl %edx           /*edx = add_in1 + 4(i + r*mo)*/

    movl (%edx), %eax   /*eax = inmatdata1[i + r * matorder]*/
    movl (%ecx), %ecx   /*ecx = inmatdata2[c + i * matorder]*/
    mul %ecx            /*eax = inmatdata1[i + r * matorder] 
                                * inmatdata2[c + i * matorder]*/
    addl %eax, -4(%ebp)

    jmp incr_3


incr_3:
    addl $1, %ebx
    cmpl 20(%ebp), %ebx
    jnb incr_2
    jmp for_loop_3

incr_2:
    /*i is ebx*/
    /*r is esi*/
    /*c is edi*/
    /*outmatdata[c + r * matorder] = elem;*/
    movl %esi, %eax     /*eax = r*/
    movl 20(%ebp), %ecx /*ecx = mo   */
    mul %ecx            /*eax = r*mo */
    addl %edi, %eax     /*eax = c+ r*mo*/
    movl $4, %ecx       /*ecx = 4*/
    mul %ecx            /*eax = 4(c+ r*mo)*/
    movl 16(%ebp), %ecx /*ecx = start_out*/
    addl %eax, %ecx     /*ecx = start_out + 4(c+ r*mo)*/
    popl %edx           /*%edx = -4(%ebp)*/
    
    movl %edx, (%ecx)

    addl $1, %edi


    cmpl %edi, 20(%ebp)
    jb incr_1
    jmp for_loop_2

incr_1:
    addl $1, %esi
    jmp for_loop_1
    
end:
    leave          /* restore ebp and esp */
    ret            /* return to the caller */

