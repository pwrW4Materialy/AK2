.bss
    .comm controlWord, 2

.text
.global checkExc, clrMasks, maskExc, testDivByZero
.type checkExc, @function
.type maskExc, @function
.type testDivByZero, @function

checkExc:
    mov $0, %rax
    fstsw %ax  # store status word
    fwait
    and $0x0ff, %ax     # clear all but exception bits
ret                     # return rax: 0 = no exceptions

clrMasks:
    fnstcw controlWord
    fwait
    mov controlWord, %ax
    and $0xffc0, %ax
    mov %ax, controlWord
    fldcw controlWord   # load control word
ret

maskExc:                # exception type in %rdi
    fnstcw controlWord
    fwait
    mov controlWord, %ax
    or %di, %ax
    mov %ax, controlWord
    fldcw controlWord
ret

testDivByZero:
    fldz
    fld1
    fdivp  
    fstp %st    # cleanup
ret
