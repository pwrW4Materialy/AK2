# Obliczanine pierwiastka kwadratowego z dokładnością do części całkowitej
.data
    STDIN = 0
    STDOUT = 1
    SYSWRITE = 1
    SYSREAD = 0
    SYSEXIT = 60
    EXIT_SUCCESS = 0
    BUFLEN = 512

    txt: .ascii "Podano znak inny niz cyfra!\n"
    txt_len=.-txt

.bss
    .comm textin, 512
    .comm textout, 512

.text
    .globl _start 
    _start:
    movq $SYSREAD, %rax
    movq $STDIN, %rdi
    movq $textin, %rsi
    movq $BUFLEN, %rdx
    syscall

    movq %rax, %r8
    dec %r8         # -'\n'
    movq $0, %rbx	# wyzerowanie rejestru b
    movq $0, %rdi	# iterator
    movq $10, %r10	# podstawa
    movq $0, %rax	# liczba dziesietnie

    to_number:
        movb textin(, %rdi, 1), %bl
        cmp $'0', %bl
        jl not_number
        cmp $'9', %bl
        jg not_number

        sub $'0', %bl

        mul %r10
        add %rbx, %rax

        inc %rdi
        cmp %r8, %rdi
        jl to_number

    movq $0, %r8	# pierwiastek
    movq $1, %rdi   # kolejne l. nieparzyste
    movq $0, %r12   # suma -||-

    square_root:
        add %rdi, %r12
        add $2, %rdi
        inc %r8
        cmp %rax, %r12
        jle square_root

    dec %r8	# dolne oszacowanie

    movq %r8, %rax
    movq $0, %r8
    to_stack:
        div %r10
        add $'0', %rdx
        push %rdx
        movq $0, %rdx
        inc %r8
        cmp $0, %rax
        jg to_stack

    movq $0, %rdi
    to_text:
        pop textout(, %rdi, 1)
        inc %rdi
        cmp %r8, %rdi
        jl to_text

    movb $'\n', textout(, %rdi, 1)

    movq $SYSWRITE, %rax
    movq $STDOUT, %rdi
    movq $textout, %rsi
    movq $BUFLEN, %rdx
    syscall
    jmp exit

    not_number:
    movq $SYSWRITE, %rax
    movq $STDOUT, %rdi
    movq $txt, %rsi
    movq $txt_len, %rdx
    syscall

    exit:
    movq $SYSEXIT, %rax
    movq $EXIT_SUCCESS, %rdi
    syscall
