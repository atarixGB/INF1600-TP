.globl	_ZNK9Rectangle12PerimeterAsmEv

factor: .float 2.0 /* use this to mult by two */

_ZNK9Rectangle12PerimeterAsmEv:
        push %ebp      /* save old base pointer */
        mov %esp, %ebp /* set ebp to current esp */

        mov 8(%ebp), %eax       # eax = this

        fld 4(%eax)             # st[0] = this->length_
        fld 8(%eax)             # st[0] = this->width_, st[1] = this->length_

        faddp                   # st[0] = this->length_ + this->width_
        fld factor              # st[0] = 2.0, st[1] = this->length_ + this->width_
        fmulp                   # st[0] = 2.0 * (this->length_ + this->width_)
        
        leave          /* restore ebp and esp */
        ret            /* return to the caller */
