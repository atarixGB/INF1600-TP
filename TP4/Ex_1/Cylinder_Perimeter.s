.globl	_ZNK8Cylinder12PerimeterAsmEv

factor: .float 2.0 /* use this to mult by two */

_ZNK8Cylinder12PerimeterAsmEv:
        push %ebp      /* save old base pointer */
        mov %esp, %ebp /* set ebp to current esp */
        
        mov 8(%ebp), %eax       # eax = this

        fld 4(%eax)             # st[0] = this->radius_
        fldpi                   # st[0] = pi, st[1] = this->radius_
        fmulp                   # st[0] = pi * this->radius_
        fld factor              # st[0] = 2.0, st[1] = pi * this->radius_
        fmulp                   # st[0] = 2.0 * pi * this->radius_                           
        
        leave          /* restore ebp and esp */
        ret            /* return to the caller */
