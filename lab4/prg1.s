.data
    SYSEXIT = 60
    EXIT_SUCCESS = 0

    decimal: .asciz "%d"
    float: .asciz "%f"
    result: .asciz "%lf\n%lf\n"
.bss
    .comm num1, 8
    .comm num2, 8

.text
    .global main 
    main:
    sub $8, %rsp    # align stack to 16 bytes

    mov $0, %rax
    mov $float, %rdi
    mov $num1, %rsi
    call scanf

    mov $0, %rax
    mov $decimal, %rdi
    mov $num2, %rsi
    call scanf

    mov $1, %rax
    mov num2, %rdi
    movss num1, %xmm0
    call func
    # result in %xmm0
    movsd %xmm0, %xmm1

    mov $2, %rax
    mov $result, %rdi
    call printf

    add $8, %rsp
    movq $SYSEXIT, %rax
    movq $EXIT_SUCCESS, %rdi
    syscall
