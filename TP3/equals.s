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

# --------------------------------------
# ---------- WORK IN PROGRESS ----------
# --------------------------------------

matrix_equals_asm:
        push %ebp      /* Save old base pointer */
        mov %esp, %ebp /* Set ebp to current esp */

        pushl %ebx              # pour pouvoir utiliser ebx, edi, esi
        pushl %edi
        pushl %esi

        subl $16, %esp          # pour allouer de l'espace sur la pile aux 
                                # variables locales (c, r) et +
        
        movl $0, -4(%ebp)       # r = 0
        movl $0, -8(%ebp)       # c = 0

for_loop_rows:
        movl 16(%ebp), %eax     # eax = matorder
        movl -4(%ebp), %ecx     # ecx = r
        cmp %eax, %ecx          # matorder <= r ? 
        jge equal               # si r > matorder, sauter a "equal"

for_loop_columns:  
        movl -8(%ebp), %ecx     # ecx = c
        cmp %eax, %ecx          # matorder <= c ?
        jge increment_row       # si c > matorder, sauter a "increment_col"

        # condition if
        # intmatdata1[c + r * matorder]
        movl 16(%ebp), %ebx     # ebx = matorder
        movl -4(%ebp), %eax     # eax = r
        mul %ebx                # eax = r * matorder
        movl %eax, %esi         # esi = r * matorder
        movl -8(%ebp), %eax     # eax = c
        addl %esi, %eax         # eax = c + r * matorder
        movl 8(%ebp), %edi      # edi = inmatdata1 (adresse)
        movl (%edi,%eax,4), %ecx  # ecx = inmatdata1[c +  r * matorder]

        # intmatdata2[c +  r * matorder]
        movl 16(%ebp), %ebx     # ebx = matorder
        movl -4(%ebp), %eax     # eax = r
        mul %ebx                # eax = r * matorder
        movl %eax, %esi         # esi = r * matorder
        movl -8(%ebp), %eax     # eax = c
        addl %esi, %eax         # eax = c + r * matorder
        movl 12(%ebp), %edi     # edi = inmatdata2 (adresse)
        movl (%edi,%eax,4), %edx  # eax = inmatdata2[c +  r * matorder]

        # comparaison des valeurs de chaque matrice
        cmp %ecx, %edx          # matdata1[c +  r * matorder] != matdata2[c +  r * matorder] ?       
        jne not_equal           # branchement non conditionel vers "not_equal"
        movl -8(%ebp), %eax     # eax = c
        addl $1, -8(%ebp)       # c = c + 1
        jmp for_loop_columns       # branchement vers for_loop_columns

increment_row:
        movl -4(%ebp), %eax     # eax = r
        addl $1, %ecx           # ecx = r + 1
        movl %ecx, -4(%ebp)     # r = r + 1
        jmp for_loop_rows       # branchement non conditionel vers "for_loop_rows"

not_equal:
        movl $0, %eax           # eax = 0 (valeur de retour)
        jmp end

equal:
        movl $1, %eax           # eax = 1 (valeur de retour)

end:
        addl $16, %esp          # pour depiler les espaces memoires allouees
        popl %esi               # pour depiler/liberer les registres esi, edi et ebx      
        popl %edi
        popl %ebx
        leave          /* Restore ebp and esp */
        ret            /* Return to the caller */
