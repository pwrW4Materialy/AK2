.data
    SYSEXIT = 60
    EXIT_SUCCESS = 0
    SYSREAD = 0
    SYSWRITE = 1
    STDOUT = 1
    SYSOPEN = 2
    SYSCLOSE = 3
    FREAD = 0
    FWRITE = 1
    O_RDONLY = 00
    O_WRONLY = 01
    O_RDWR = 02
    O_CREAT = 0100
    O_TRUNC = 01000
    O_APPEND = 02000
    O_WR_CRT_TRNC = 01101
    BUFLEN = 1024

    f_in: .ascii "in\0"
    f_out: .ascii "out\0"

.bss
    .comm buf_in, 1024
    .comm buf_out, 1024
    .comm num_buf, 1024

.text
    .globl _start
    _start:

    movq $SYSOPEN, %rax
    movq $f_in, %rdi
    movq $FREAD, %rsi
    movq $O_RDONLY, %rdx
    syscall

    movq %rax, %rdi  # file handle
    movq $SYSREAD, %rax
    movq $buf_in, %rsi
    movq $BUFLEN, %rdx
    syscall

    movq %rax, %r8  
    sub $2, %r8       # taking 2 bytes at a time

    movq $SYSCLOSE, %rax    # file handle still in %rdi
    syscall

    movq %r8, %rdi
    movq $0, %rsi
    read:
        movw buf_in(, %rdi, 1), %bx
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
        movb %bl, num_buf(, %rsi, 1)

        inc %rsi
        sub $2, %rdi
        cmp $0, %rdi
        jge read
    movq %r8, %rax
    movq $0, %rdx
    movq $2, %r8
    div %r8
    movq %rax, %r10
    inc %r10            # number of bytes
    cmp $0, %rdx
    je even

    movq $0, %rdi
    movb buf_in(, %rdi, 1), %al
    call to_number
    cmp $0, %ah
    jne exit
    movb %al, num_buf(, %rsi, 1)
    inc %r10

    even:
    movq $0, %rdi
    movq $0, %rsi
    movq $0, %r9
    
    to_octo:
        movq $0, %rbx
        movq $0, %rax
        movq $0, %rcx
        movb num_buf(, %rdi, 1), %al
        inc %rdi
        movb num_buf(, %rdi, 1), %bl
        shl $8, %rbx
        inc %rdi
        movb num_buf(, %rdi, 1), %cl
        shl $16, %rcx
        inc %rdi
        or %rbx, %rax
        or %rcx, %rax
        movq $0, %rbx
        to_stack:
            movb %al, %bl
            and $7, %bl
            shr $3, %rax
            add $'0', %bl
            push %rbx
            inc %rsi
            inc %r9
            cmp $8, %r9
            jl to_stack

        movq $0, %r9
        cmp %r10, %rdi
        jl to_octo

    movq %r10, %rax     # (n of bytes/3) *8 
    movq $0, %rdx
    movq $3, %r9
    div %r9
    cmp $0, %rdx
    je no_remainder
    inc %rax
    no_remainder:
    movq $8, %r8
    mul %r8
    movq %rax, %r9  # amount of output numbers
    movq $0, %rdi
    movb $0, %cl    # 1st non-zero flag
    to_text:
        pop %rbx
        cmp $1, %cl
        je not_begining_zero
            cmp $'0', %bl
            jne first_number
            dec %rax
            jmp to_text
            first_number:
            movb $1, %cl

        not_begining_zero:   
        movb %bl, buf_out(, %rdi, 1)
        inc %rdi
        cmp %rax, %rdi
        jl to_text
    movq %rdi, %r9

    movq $SYSOPEN, %rax
    movq $f_out, %rdi
    movq $FWRITE, %rsi
    movq $O_WR_CRT_TRNC, %rdx
    syscall

    movq %rax, %rdi  # file handle
    movq $SYSWRITE, %rax
    movq $buf_out, %rsi
    movq %r9, %rdx
    syscall

    movq $SYSCLOSE, %rax    # file handle still in %rdi
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
