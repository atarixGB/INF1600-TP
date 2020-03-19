# # segmentation fault to fix

.global matrix_transpose_asm

matrix_transpose_asm:
        push %ebp      /* save old base pointer */
        mov %esp, %ebp /* set ebp to current esp */
        
        subl $8, %esp           # memory for local variables r, c

        push %edi

        movl $0, -4(%ebp)       # r = 0

for_loop_rows:

        movl -4(%ebp), %eax     # eax = r
        movl 16(%ebp), %ecx     # ecx = matorder
        cmp %ecx, %eax
        jge end                 # jump to end if r >= matorder

        movl $0, -8(%ebp)       # c = 0

for_loop_column:
        movl -8(%ebp), %eax     # eax = c
        movl 16(%ebp), %ecx     # ecx = matorder
        cmp %ecx, %eax
        jge next_row

        # inmatdata[r + c * matorder]
        movl -8(%ebp), %eax     # eax = c
        movl 16(%ebp), %ecx     # ecx = matorder
        mul %ecx                # eax = c * matorder
        movl -4(%ebp),%ecx      # ecx = r
        addl %ecx, %eax         # eax = r + c * matorder
        movl 8(%ebp), %ecx      # ecx = address of intmatdata
        movl (%ecx,%eax,4), %edi  # edi = intmatdata[r + c * matorder]

        movl 12(%ebp), %edx     # edx = adress of outmadata
        
        # movl -4(%ebp), %eax     # eax = r
        movl 16(%ebp), %ecx     # ecx = matorder
        mul %ecx                # eax = r * matorder
        movl -8(%ebp),%ecx      # ecx = c
        addl %ecx, %eax         # eax = c + r * matorder

        # move inmatdata into outmatdata
        movl %edi, (%edx,%eax,4)        # outmatdata[c + r * matorder] = inmatdata[r + c * matorder]

        # next row
        movl -8(%ebp), %eax             # eax = c
        addl $1, %eax                   # eax = c + 1
        movl %eax, -8(%ebp)             # c = c + 1

        jmp for_loop_column

next_row:
        movl -4(%ebp), %eax     # eax = r
        addl $1, %eax           # eax = r + 1
        movl %eax, -4(%ebp)     # r = r + 1
        jmp for_loop_rows
        # todo

end:        
        pop %edi

        addl $8, %esp

        leave          /* restore ebp and esp */
        ret            /* return to the caller */
