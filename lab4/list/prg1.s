# Wywoływanie zewnętrznych funkcji w C
.data
    SYSEXIT = 60
    EXIT_SUCCESS = 0

    decimal: .asciz "%d"
    float: .asciz "%f"
    result: .asciz "%f\n"
.bss
    .comm num1, 8
    .comm num2, 8

.text
    .global main 
    main:
    push %rbp
    mov %rsp, %rbp

    mov $0, %rax
    mov $decimal, %rdi
    mov $num1, %rsi
    call scanf

    mov $0, %rax
    mov $float, %rdi
    mov $num2, %rsi
    call scanf

    mov $1, %rax
    mov num1, %rdi
    movss num2, %xmm0
    call func

    mov $1, %rax
    mov $result, %rdi
    cvtss2sd %xmm0, %xmm0
    call printf

    mov %rbp, %rsp
    pop %rbp
    movq $SYSEXIT, %rax
    movq $EXIT_SUCCESS, %rdi
    syscall
