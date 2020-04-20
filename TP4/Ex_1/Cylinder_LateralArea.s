.globl	_ZNK8Cylinder14LateralAreaAsmEv
factor: .float 2.0 /* use this to mult by two */

_ZNK8Cylinder14LateralAreaAsmEv:
        push %ebp               /* save old base pointer */
        mov %esp, %ebp          /* set ebp to current esp */
        
        movl 8(%ebp), %eax      /* eax = address of object */
        /* formula : 2*pi*radius*height */
        fld 4(%eax)             /* st[0] = radius */
        fld 8(%eax)             /* st[0] = height, st[1] = radius */
        fmulp                   /* st[0] = radius * height */
        fldpi                   /* st[0] = pi, st[1] = radius * height */
        fmulp                   /* st[0] = pi * radius * height */
        fld factor              /* st[0] = 2.0, st[1] = pi * radius * height */

        fmulp                   /* st[0] = 2.0 * pi * radius * height*/

        leave                   /* restore ebp and esp */
        ret                     /* return to the caller */
