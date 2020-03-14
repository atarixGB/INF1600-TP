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

        subl $8, %esp           # pour allouer de l'espace sur la pile aux 
                                # variables locales (c, r)
        
        movl $0, -4(%ebp)       # r = 0
        movl -4(%ebp), %ecx     # ecx = r = 0
        movl $0, -8(%ebp)       # c = 0
        movl -8(%ebp), %edx     # edx = c = 0

for_loop_rows:
        movl 16(%ebp), %eax     # eax = matorder
        cmpl %eax, %ecx         # matorder <= r ? 
        jge equal               # si r > matorder, sauter a "equal"

for_loop_columns:  
        cmpl %eax, %edx         # matorder <= c ?
        jge change_row          # si c > matorder, sauter a "change_row

        # condition if
        # matdata1[i]
        movl 8(%ebp), %ebx      # ebx = matdata1
        movl -4(%ebp), %eax     # eax = r
        mul %ebx                # eax = r * matdata1
        movl %eax, %esi         # esi = r * matdata1
        movl -8(%ebp), %eax     # eax = c
        addl %esi, %esi         # esi = c (eax) +  r * matdata1 (esi)

        # matdata2[i]
        movl 12(%ebp), %ebx      # ebx = matdata2
        movl -4(%ebp), %eax     # eax = r
        mul %ebx                # eax = r * matdata2
        movl %eax, %esi         # esi = r * matdata2
        movl -8(%ebp), %eax     # eax = c
        addl %esi, %edi         # edi = c (eax) +  r * matdata2 (esi)

        cmp %esi, %edi          # matdata1[i] != matdata2[i] ?       
        jne not_equal           # branchement non conditionel vers "not_equal"
        movl %edx, %eax;        # eax = c
        addl $1, %edx           # edx = c + 1

change_row:
        movl %ecx, %eax         # eax = r
        addl $1, %ecx           # ecx = r + 1
        jmp for_loop_rows       # branchement non conditionel vers "for_loop_rows"

not_equal:
        movl $0, %eax           # eax = 0 (valeur de retour)
        jmp end

equal:
        movl $1, %eax           # eax = 1 (valeur de retour)

end:
        subl $8, %esp           # pour depiler les variables locales
        popl %esi               # pour depiler les registres esi, edi et ebx      
        popl %edi
        popl %ebx
        leave          /* Restore ebp and esp */
        ret            /* Return to the caller */
