.globl	_ZNK9Rectangle7AreaAsmEv

_ZNK9Rectangle7AreaAsmEv:
        push %ebp      /* save old base pointer */
        mov %esp, %ebp /* set ebp to current esp */
        
        mov 8(%ebp), %eax       # eax = this

        fld 4(%eax)             # st[0] = this->length_
        fld 8(%eax)             # st[0] = this->width_, st[1] = this->length_

        fmulp                   # st[0] = this->width * this->length_
        
        leave          /* restore ebp and esp */
        ret            /* return to the caller */
