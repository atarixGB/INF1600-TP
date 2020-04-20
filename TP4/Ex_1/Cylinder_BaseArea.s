.globl	_ZNK8Cylinder11BaseAreaAsmEv
factor: .float 2.0 /* use this to mult by two */

_ZNK8Cylinder11BaseAreaAsmEv:
        push %ebp                       /* save old base pointer        */
        mov %esp, %ebp                  /* set ebp to current esp       */
        
        movl 8(%ebp), %eax              /* eax = address of object      */
        
        /*formula : area = pi*r*r */
        fld 4(%eax)                     /* st[0] = radius               */
        fld 4(%eax)                     /* st[0] = st[1] = radius       */
        fmulp                           /* st[0] = radius * radius      */
        fldpi                           /* st[0] = pi, st[1] = radius^2 */ 
        fmulp                           /* st[0] = pi * radius^2        */


        leave          /* restore ebp and esp */
        ret            /* return to the caller */
