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

.globl matrix_equals_asm

# --------------------------------------
# ---------- WORK IN PROGRESS ----------
# --------------------------------------

matrix_equals_asecxm:
        push %ebp      /* Save old base pointer */
        mov %esp, %ebp /* Set ebp to current esp */

        subl $8, %esp           # pour allouer de l'espace sur la pile aux 
                                # variables locales (c, r)
        
        movl $0, -4(%ebp)       # r = 0
        movl -4(%ebp), %ecx     # ecx = r = 0
        movl $0, -8(%ebp)       # c = 0
        movl -8(%ebp), %edx     # edx = c = 0

for_loop_rows:
        movl 16(%ebp), %eax     # eax = matorder
        cmpl %eax, %ecx         # matorder == r ? 
        jge equal               # si r > matorder, sauter a "equal"

for_loop_columns:  
        cmpl %eax, %edx         # matorder == c ?
        jge change_row          # si c > matorder, sauter a "change_row

/*
if:
        jmp not_equal           # branchement non conditionel vers "not_equal"

change_row:
        movl %ecx, %eax         # eax = r
        addl $1, %ecx           # ecx = eax + 1 = r + 1
        jmp for_loop_columns    # branchement non conditionel vers "for_loop_columns"
*/

not_equal:
        movl $0, %eax           # eax = 0 (valeur de retour)
        jmp end

equal:
        movl $1, %eax           # eax = 1 (valeur de retour)

end:
        leave          /* Restore ebp and esp */
        ret            /* Rnot_equaleturn to the caller */
