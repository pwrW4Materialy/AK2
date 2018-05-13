# based on: https://stackoverflow.com/questions/18805627/decode-an-aproximation-of-sin-taylor-series
# float sine(float x, int j)
#   float val = 1;
#   for (int k = j - 1; k >= 0; --k)
#        val = 1 - x*x/(2*k+2)/(2*k+3)*val;
#
#   return x * val;

.bss
    .comm divisor, 4

.text
.global sinusApprox
.type sinusApprox, @function

sinusApprox:
    push %rbp
    mov %rsp, %rbp
    sub $8, %rsp
    movsd %xmm0, (%rsp)
    mov %rdi, %r10  # number of steps
    dec %r10        # k = j - 1
    mov $2, %r11    # multiplier for divisor
    
    finit
    fld1            # ST(3) = 1.0 (const)
    fldl (%rsp)
    fmul %st, %st   # ST(2) = x^2 (const)
    fld1            # ST(1) = val

sin_loop:
    fld %st(1)      # ST(0) = x^2       
                    
    mov %r10, %rax
    mul %r11
    add $2, %rax        
    mov %rax, divisor   # divisor = 2*k+2

    fidiv divisor       # ST(0) = x^2 / -||-
    incl divisor        # divisor = 2*k+3 
    fidiv divisor

    fmul %st(1), %st    # ST(0) = x^2 / (2*k+2) / (2*k+3) * val
    fsubr %st(3), %st   # ST(0) = 1- -||- = new val
    fxch                # ST(1) = ST(0)
    fstp %st            # pop ST(0) to load x^2 again later

    dec %r10
    cmp $0, %r10
    jge sin_loop

    fldl (%rsp)         # ST(0) = x, ST(1) = val
    fmul %st(1), %st
    fstpl (%rsp)
    movsd (%rsp), %xmm0 # return result in xmm0

    fstp %st    # cleanup
    fstp %st
    fstp %st
    mov %rbp, %rsp
    pop %rbp
ret
