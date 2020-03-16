.global matrix_row_aver_asm

matrix_row_aver_asm:
        push %ebp      			/* Save old base pointer */
        mov %esp, %ebp 			/* Set ebp to current esp */

        subl  $12, %esp         # variables locales: r, c, elem

        movl $0, -4(%ebp)       # r = 0
        movl $0, -12(%ebp)      # elem = 0

    for_loop_rows:
        movl -4(%ebp), %ecx     # ecx = r
        movl 16(%ebp), %eax     # eax = matorder
        cmp %eax, %ecx
        jge end

        movl $0, -8(%ebp)       # c = 0
    
    for_loop_columns:
        movl -8(%ebp), %ecx     # ecx = c
        movl 16(%ebp), %eax     # eax = matorder
        cmp %eax, %ecx
        jge compute_average     # if c > matorder, jump to "compute_average", else continue

        # inmatdata[c + r * matorder]
        movl -4(%ebp), %eax     # eax = r
        movl 16(%ebp), %ecx     # ecx = matorder
        mul %ecx                # eax = r * matorder
        movl -8(%ebp), %ecx     # ecx = c
        addl %ecx, %eax         # eax = c + r * matorder
        movl 8(%ebp), %ecx      # ecx = adress of inmatdata
        movl (%ecx,%eax,4), %ecx    # ecx = inmatdata[c + r * matorder]
        movl -12(%ebp), %eax    # eax = elem
        addl %ecx, %eax         # eax = elem + inmatdata[c + r * matorder]
        movl %eax, -12(%ebp)    # elem = elem + inmatdata[c + r * matorder]

        # increment column
        movl -8(%ebp), %eax     # eax = c
        addl $1, %eax           # eax = c + 1
        mov %eax, -8(%ebp)      # c = c + 1
        jmp for_loop_columns          # jump to "for_loop_columns"

    compute_average:
        movl -12(%ebp), %eax    # eax = elem
        movl 16(%ebp), %ecx     # ecx = matorder
        divl %ecx               # eax = elem / matorder
        movl %eax, %ecx         # ecx = elem / matorder
        
        # outmatdata[r]
        movl 12(%ebp), %eax     # eax = address of outmatdata
        movl -4(%ebp), %ecx     # ecx = r
        movl (%eax,%ecx,4), %eax    # eax = outmatada[r]
        mov %eax, 12(%ebp)      # outmatdata = outmatada[r]

        movl -4(%ebp), %eax     # eax = r
        addl $1, %eax           # eax = r + 1
        mov %eax, -8(%ebp)      # r = r + 1
        jmp for_loop_rows

	end:

        leave          			/* Restore ebp and esp */
        ret
