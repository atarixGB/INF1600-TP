# # segmentation fault to fix

.global matrix_transpose_asm

matrix_transpose_asm:
        push %ebp      /* save old base pointer */
        mov %esp, %ebp /* set ebp to current esp */

        pushl %ebx              # add working register
        sub $8, %esp            # local variables r, c

        movl $0, -8(%ebp)       # r = 0

for_loop1:
        movl -8(%ebp), %eax     # eax = r
        cmp 16(%ebp), %eax      # compare matorder with r
        jnb end
        movl $0, -12(%ebp)      # c = 0
        
for_loop2:
        movl -12(%ebp), %eax    # eax = c
        cmp 16(%ebp), %eax      # compare matorder with c
        jnb change_row          # if !(c < matorder), change row

        # value of intmatdata[r + c * matorder]
        movl 16(%ebp), %ebx     # ebx = matorder
        mull %ebx               # eax = c * matorder
        movl -8(%ebp), %ebx     # ebx = r
        addl %ebx, %eax         # eax = r + c * matorder
        movl 8(%ebp), %ebx      # ebx = inmatdata address
        movl (%ebx, %eax, 4), %ebx      # ebx = inmatdata[r+c*matorder]

        movl -8(%ebp), %eax     # eax = r
        movl 16(%ebp), %ecx     # ecx = matorder
        mull %ecx               # eax = r * matorder
        movl -12(%ebp), %ecx    # ecx = c
        addl %ecx, %eax         # eax = c + r * matorder
        movl 12(%ebp), %ecx     # ecx = outmatdata address
        
        movl %ebx, (%ecx,%eax,4)        # outmatdata[c + r * matorder] = inmatdata[r + c * matorder]

        movl -12(%ebp), %edx    # edx = c
        incl %edx               # c + 1
        movl %edx, -12(%ebp)    # c = c + 1
        jmp for_loop2               # jumo to loop2
        
change_row:
        movl -8(%ebp), %eax     # eax = r
        incl %eax               # r + 1
        movl %eax, -8(%ebp)     # r = r + 1
        jmp for_loop1               # jump to loop1

end:        
        addl $8, %esp           # remove local variables from stack
        popl %ebx               # remove reserved register

        leave          /* restore ebp and esp */
        ret            /* return to the caller */
