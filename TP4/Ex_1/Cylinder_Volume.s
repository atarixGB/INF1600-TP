.globl	_ZNK8Cylinder9VolumeAsmEv


_ZNK8Cylinder9VolumeAsmEv:
        push %ebp                /* save old base pointer */
        mov %esp, %ebp           /* set ebp to current esp */
        movl 8(%ebp), %eax       /* eax = address of object */
        
        /* height * radius * radius * pi*/

        fld 4(%eax)                     /* st[0] = radius               */
        fld 4(%eax)                     /* st[0] = st[1] = radius       */
        fmulp                           /* st[0] = radius * radius      */
        fldpi                           /* st[0] = pi, st[1] = radius^2 */ 
        fmulp                           /* st[0] = pi * radius^2        */
        fld 8(%eax)                     /* st[0] = height, st[1] = pi * radius^2*/
        fmulp

        
        leave          /* restore ebp and esp */
        ret            /* return to the caller */
