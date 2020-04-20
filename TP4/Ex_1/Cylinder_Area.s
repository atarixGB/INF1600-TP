.globl	_ZNK8Cylinder7AreaAsmEv
factor: .float 2.0 /* use this to mult by two */

_ZNK8Cylinder7AreaAsmEv:
        push %ebp      /* save old base pointer */
        mov %esp, %ebp /* set ebp to current esp */
        
        mov 8(%ebp), %eax       # eax = this

        fld factor              # st[0] = 2.0
        fld 8(%eax)             # st[0] = height
        fmulp                   # st[0] = 2*height
        fld 4(%eax)             # st[0] = radius
        faddp                   # st[0] = radius + 2.0 * height
        fld 4(%eax)             # st[0] = radius
        fmulp                   # st[0] = radius * (radius + 2.0 * height)
        fldpi                   # st[0] = pi
        fmulp                   # st[0] = pi * radius * (radius + 2.0 * height)

        leave          /* restore ebp and esp */
        ret            /* return to the caller */
