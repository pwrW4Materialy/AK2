.data
    SYSREAD = 0
    SYSWRITE = 1
    SYSEXIT = 60
    STDOUT = 1
    STDIN = 0
    EXIT_SUCCESS = 0
    BUFLEN = 512

    buf: .ascii "Hello, world!\n"
    buf_len= .-buf

.bss
    .comm buf_in, 512
    .comm buf_out, 512


.text
.globl _start

_start:
    movq $SYSREAD, %rax
    movq $STDIN, %rdi
    movq $buf_in, %rsi
    movq $BUFLEN, %rdx
    syscall

    dec %rax	#'\n'
    movq $0, %rdi	#licznik
    zamien_litery:
        movb buf_in(,%rdi, 1), %bh
        cmp $'A', %bh
        jl nie_litera

        cmp $'Z', %bh
        jle litera

        cmp $'a', %bh
        jl nie_litera

        cmp $'z', %bh
        jg nie_litera

        litera:
        movb $0x20, %bl
        xor %bl, %bh

        nie_litera:
        movb %bh, buf_out(, %rdi, 1)
        inc %rdi
        cmp %rax, %rdi
        jl zamien_litery

    movb $'\n', buf_out(, %rdi, 1)

    movq $SYSWRITE, %rax
    movq $STDOUT, %rdi
    movq $buf_out, %rsi
    movq $BUFLEN, %rdx
    syscall

    movq $SYSEXIT, %rax
    movq $EXIT_SUCCESS, %rdi
    syscall
