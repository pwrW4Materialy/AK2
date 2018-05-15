.text
.global lnApprox
.type lnApprox, @function

lnApprox:
    push %rbp
    mov %rsp, %rbp
    sub $8, %rsp
    movsd %xmm0, (%rsp)
    mov %rdi, %r10  # number of steps
    
    finit
    fld1            # ST(3|4) = 1.0 (divisor)
    fldl (%rsp)     # ST(2|3) = x
    fldz            # ST(1|2) = result
    fld1            # ST(0|1) = next pows of x
                    # ST(  0) = buf

ln_loop:
    fmul %st(2), %st    # ST(0) * x
    fld %st             # store pow of x
    fdiv %st(4), %st    # ST(0) = ST(0)/ ST(4)
    faddp %st, %st(2)   # ST(2) = ST(0) + ST(2) & pop
    fld1                # inc divisor
    faddp %st, %st(4)   # 
    fchs                # next pow x * (-1)

    dec %r10
    cmp $0, %r10
    jg ln_loop
    
    fstp %st            # pop pows of 2
    fstpl (%rsp)        # pop result
    movsd (%rsp), %xmm0 # return result in xmm0

    fstp %st    # cleanup
    fstp %st
    mov %rbp, %rsp
    pop %rbp
ret
