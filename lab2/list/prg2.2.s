.data
    SYSEXIT = 60
    SYSREAD = 0
    SYSWRITE = 1
    STDOUT = 1
    STDIN = 0
    EXIT_SUCCESS = 0
    BUFLEN = 1024

.bss
    .comm num1_buf, 1024   # num1 in char
    .comm num1, 1024       # num1 decoded to hex
    .comm num2_buf, 1024
    .comm num2, 1024
    .comm sum_buf, 1024
    .comm sum_out, 1024
# %r14 - no. of num1
# %r15 - no. of num2
.text
    .globl _start
    _start:
    movq $SYSREAD, %rax
    movq $STDIN, %rdi
    movq $num1_buf, %rsi
    movq $BUFLEN, %rdx
    syscall
    movq %rax, %r14
    sub $3, %r14         # -\n, taking 2 bytes at a time


    movq $SYSREAD, %rax
    movq $STDIN, %rdi
    movq $num2_buf, %rsi
    movq $BUFLEN, %rdx
    syscall
    movq %rax, %r15
    sub $3, %r15

    num1_decode:
    movq %r14, %r8
    movq %r8, %rdi
    movq $0, %rsi
        read_num1:
            movw num1_buf(, %rdi, 1), %bx
            movb %bl, %al
            call to_number
            cmp $0, %ah
            jne exit

            movb %al, %bl
            shl $4, %bl

            movb %bh, %al
            call to_number
            cmp $0, %ah
            jne exit

            or %al, %bl
            movb %bl, num1(, %rsi, 1)

            inc %rsi
            sub $2, %rdi
            cmp $0, %rdi
            jge read_num1
        movq %r8, %rax
        movq $0, %rdx
        movq $2, %r8
        div %r8
        movq %rax, %r14
        inc %r14            # number of bytes
        cmp $0, %rdx
        je num2_decode

        movq $0, %rdi       # if odd number
        movb num1_buf(, %rdi, 1), %al
        call to_number
        cmp $0, %ah
        jne exit
        movb %al, num1(, %rsi, 1)
        inc %r14

    num2_decode:
    movq %r15, %r8
    movq %r8, %rdi
    movq $0, %rsi
        read_num2:
            movw num2_buf(, %rdi, 1), %bx
            movb %bl, %al
            call to_number
            cmp $0, %ah
            jne exit

            movb %al, %bl
            shl $4, %bl

            movb %bh, %al
            call to_number
            cmp $0, %ah
            jne exit

            or %al, %bl
            movb %bl, num2(, %rsi, 1)

            inc %rsi
            sub $2, %rdi
            cmp $0, %rdi
            jge read_num2
        movq %r8, %rax
        movq $0, %rdx
        movq $2, %r8
        div %r8
        movq %rax, %r15
        inc %r15            # number of bytes
        cmp $0, %rdx
        je equal

        movq $0, %rdi
        movb num2_buf(, %rdi, 1), %al
        call to_number
        cmp $0, %ah
        jne exit
        movb %al, num2(, %rsi, 1)
        inc %r15

    equal:
    movq $0, %rdi
    movq $0, %r11           # iterator for sum_buf
    movq $0, %r12           # iterator for to_sum_buf loop
    add_no_carry:
        movq num1(, %rdi, 8), %rax
        movq num2(, %rdi, 8), %rbx
        inc %rdi
        add %rbx, %rax
        pushf
        
    add_carry:
        call to_sum_buf
        popf
        movq num1(, %rdi, 8), %rax
        movq num2(, %rdi, 8), %rbx
        inc %rdi
        adc %rbx, %rax
        pushf
        cmp $0, %rax
        jg add_carry
        popf
        adc $0, %rax        # add carry, if %rax=ff..f+1
        cmp $0, %rax
        je print
        call to_sum_buf
    
    print:
    movq $0, %rdi
    dec %r11                # %r11 still pointing to next (empty) byte for sum_buf
    movb $0, %cl            # 1st non-zero flag
    flip_sum:
        movb sum_buf(, %r11, 1), %bl
        cmp $1, %cl
        je not_begining_zero
            cmp $'0', %bl
            jne first_number
            dec %r11
            jmp flip_sum
            first_number:
            movb $1, %cl

        not_begining_zero:   
        movb %bl, sum_out(, %rdi, 1)
        dec %r11
        inc %rdi
        cmp $0, %r11
        jge flip_sum

    movb $'\n', sum_out(, %rdi, 1)

    movq $SYSWRITE, %rax
    movq $STDOUT, %rdi
    movq $sum_out, %rsi
    movq $BUFLEN, %rdx
    syscall

    
exit:
    movq $SYSEXIT, %rax
    movq $EXIT_SUCCESS, %rdi
    syscall

to_number:          # number in %al
    cmp $'0', %al   # sets %ah to 0 if correct, 1 otherwise
    jl not_number
    cmp $'9', %al
    jle number
    cmp $'A', %al
    jl not_number
    cmp $'F', %al
    jle ucletter
    cmp $'a', %al
    jl not_number
    cmp $'f', %al
    jg not_number 

    sub $'a', %al
    add $10, %al
    jmp correct
    ucletter:
    sub $'A', %al
    add $10, %al
    jmp correct
    number:
    sub $'0', %al

    correct:    
    movb $0, %ah
    ret

    not_number:
    movb $1, %ah
    ret

to_sum_buf:            # number in %rax
    movb %al, %bl
    and $15, %bl
    cmp $9, %bl
    jle number_to_char
    add $7, %bl     # -10+17 (17='A'-'0')
    number_to_char:
    add $'0', %bl
    movb %bl, sum_buf(, %r11, 1)
    inc %r11
    inc %r12
    shr $4, %rax
    cmp $16, %r12
    jl to_sum_buf
    movq $0, %r12
    ret
