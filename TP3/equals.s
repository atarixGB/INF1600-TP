/*       STACK
    ----------------
-8  |      c       |    <-- esp
-4  |      r       |
 0  |   saved ebp  |    <-- ebp
+4  |   ret.addr.  |
+8  |   matdata1   |
+12 |   matdata2   |
+16 |   matorder   |
    ----------------
*/

.global matrix_equals_asm

matrix_equals_asm:
        push %ebp      /* Save old base pointer */
        mov %esp, %ebp /* Set ebp to current esp */

        pushl %ebx              # may be useful to have these registers
        pushl %edi
        pushl %esi

        subl $16, %esp          # to allocate memory to local variables and more
        
        movl $0, -4(%ebp)       # r = 0

for_loop_rows:
        movl 16(%ebp), %eax     # eax = matorder
        movl -4(%ebp), %ecx     # ecx = r
        cmp %eax, %ecx          
        jge equal               # if r > matorder, jump to "equal"

        movl $0, -8(%ebp)       # c = 0

for_loop_columns:
        movl 16(%ebp), %eax     # eax = matorder
        movl -8(%ebp), %ecx     # ecx = c
        cmp %eax, %ecx          
        jge increment_row       # if c > matorder, jump to "for_loop_rows"

        /* if condition */
        # intmatdata1[c + r * matorder]
        movl 16(%ebp), %ebx     # ebx = matorder
        movl -4(%ebp), %eax     # eax = r
        mul %ebx                # eax = r * matorder
        movl %eax, %ebx         # ebx = r * matorder
        movl -8(%ebp), %eax     # eax = c
        addl %ebx, %eax         # eax = c + r * matorder
        movl 8(%ebp), %ebx      # ebx = inmatdata1 (adresse)
        movl (%ebx,%eax,4), %edi  # edi = inmatdata1[c +  r * matorder]

        # intmatdata2[c +  r * matorder]
        movl 16(%ebp), %ebx     # ebx = matorder
        movl -4(%ebp), %eax     # eax = r
        mul %ebx                # eax = r * matorder
        movl %eax, %ebx         # ebx = r * matorder
        movl -8(%ebp), %eax     # eax = c
        addl %ebx, %eax         # eax = c + r * matorder
        movl 12(%ebp), %edx     # edx = inmatdata2 (adresse)
        movl (%edx,%eax,4), %esi  # esi = inmatdata2[c +  r * matorder]

        # comparaison des valeurs de chaque matrice
        cmp %esi, %edi          # matdata1[c +  r * matorder] != matdata2[c +  r * matorder] ?       
        jne not_equal           # jump to "not_equal"
        
        movl -8(%ebp), %eax     # eax = c
        addl $1, %eax           # eax = c + 1
        movl %eax, -8(%ebp)     # c = c + 1
        jmp for_loop_columns    

increment_row:
        movl -4(%ebp), %eax     # eax = r
        add $1, %eax            # eax = r + 1
        movl %eax, -4(%ebp)     # r = r + 1
        jmp for_loop_rows    # jump to "for_loop_rows"

not_equal:
        movl $0, %eax           # eax = 0 (return value in eax)
        jmp end

equal:
        movl $1, %eax           # eax = 1 (return value in eax)

end:
        addl $16, %esp          # to remove local variables from stack
        popl %esi               # to remote esi, edi, ebx from stack      
        popl %edi
        popl %ebx

        leave          /* Restore ebp and esp */
        ret            /* Return to the caller */
