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
    .comm text1, BUFLEN
    .comm text2, BUFLEN
    .comm textout, BUFLEN

.text
    .globl _start 
    _start:

num1:               # %r8 - pierwsza liczba
    movq $SYSREAD, %rax
    movq $STDIN, %rdi
    movq $text1, %rsi
    movq $BUFLEN, %rdx
    syscall

    movq %rax, %r8
    dec %r8         # -'\n'
    movq $0, %rbx	# wyzerowanie rejestru b
    movq $0, %rdi	# iterator
    movq $10, %r10	# podstawa
    movq $0, %rax	# liczba dziesietnie

    num1_decode:
        movb text1(, %rdi, 1), %bl
        cmp $'0', %bl
        jl not_number
        cmp $'9', %bl
        jg not_number

        sub $'0', %bl

        mul %r10
        add %rbx, %rax

        inc %rdi
        cmp %r8, %rdi
        jl num1_decode

    movq %rax, %r8

num2:               # %r9 - druga liczba
    movq $SYSREAD, %rax
    movq $STDIN, %rdi
    movq $text2, %rsi
    movq $BUFLEN, %rdx
    syscall

    movq %rax, %r9
    dec %r9         # -'\n'
    movq $0, %rbx	# wyzerowanie rejestru b
    movq $0, %rdi	# iterator
    movq $0, %rax	# liczba dziesietnie

    num2_decode:
        movb text2(, %rdi, 1), %bl
        cmp $'0', %bl
        jl not_number
        cmp $'9', %bl
        jg not_number

        sub $'0', %bl

        mul %r10
        add %rbx, %rax

        inc %rdi
        cmp %r9, %rdi
        jl num2_decode

    movq %rax, %r9

    push %r8
    push %r9
    call nwd

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


nwd:
    push %rbp
    mov %rsp, %rbp
    mov 16(%rbp), %rbx
    mov 24(%rbp), %rax
    cmp %rax, %rbx
    jl dont_switch
        mov %rax, %rcx
        mov %rbx, %rax
        mov %rcx, %rbx
    dont_switch:
    mov $0, %rdx
    div %rbx
    mov %rbx, %rax
    mov %rdx, %rbx
    cmp $0, %rbx
    je restore
        push %rax
        push %rbx
        call nwd
    restore:
    mov %rbp, %rsp
    pop %rbp
ret
