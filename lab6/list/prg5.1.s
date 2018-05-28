.bss
    .comm controlWord, 2

.text
.global getPrecision, setPrecision
.type getPrecision, @function
.type setPrecision, @function

getPrecision:
    fnstcw controlWord  # store control word (no-wait)
    fwait
    mov controlWord, %ax
    and $0x0300, %ax    # clear all except precision bits
    shr $8, %ax         # move the bits rightmost
ret                     # return rax: 0=single, 2=doble, 3=double-extended

setPrecision:
    fnstcw controlWord
    fwait
    mov controlWord, %ax
    and $0x0fcff, %ax   # clear precision bits
    cmp $4, %rdi        # argument in rdi
    jnl wrong_arg
    cmp $1, %rdi        # 01 is reserved
    je wrong_arg

    shl $8, %rdi        # move arg to precision bits (9,8)
    or %di, %ax         # set precision
    mov %ax, controlWord
    fldcw controlWord   # load control word

wrong_arg:
ret
