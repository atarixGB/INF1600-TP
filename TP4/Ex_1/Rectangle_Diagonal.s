.globl	_ZNK9Rectangle11DiagonalAsmEv

_ZNK9Rectangle11DiagonalAsmEv:
        push %ebp      /* save old base pointer */
        mov %esp, %ebp /* set ebp to current esp */
        
        movl 8(%ebp), %eax      # eax = this

        fld 4(%eax)     # st[0] = this->length
        fld 4(%eax)     # st[0] = this->length, st[1] = this.length
        fmulp           # st[0] = this->length * this->length

        fld 8(%eax)     # st[0] = this->width, st[1] = this->length * this->length
        fld 8(%eax)     # st[0] = this->width, st[1] = this->width, st[2] = this->length * this->length
        fmulp           # st[0] = this->width * this->width, st[1] = this->length * this->length

        faddp           # st[0] = this->width * this->width + this->length * this->length

        fsqrt
        
        leave          /* restore ebp and esp */
        ret            /* return to the caller */
