.text
.global func

.type func, @function

func:
    cvtsi2ss %rdi, %xmm1
    mulss %xmm1, %xmm0
    cvtss2si %xmm0, %rax

ret
