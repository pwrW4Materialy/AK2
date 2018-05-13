# Wczytanie argumentu całkowitoliczbowego i zmiennoprzecinkowego za pomocą funkcji bibliotecznej scanf,
# Wywołanie funkcji napisanej w języku C double f(float x, int y);
#   f(x, y) = x^2 + y^3
# Dwukrotne wypisanie wyniku za pomocą pojedynczego wywołania funkcji printf "%lf \n %lf".

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

    # align stack to 16 bytes
    sub $8, %rsp    
    
    mov $2, %rax
    mov $result, %rdi
    call printf

    add $8, %rsp
    movq $SYSEXIT, %rax
    movq $EXIT_SUCCESS, %rdi
    syscall
