# Znajdowanie sekwencji 'abc' w ciągu znaków
.data
    STDIN = 0
    STDOUT = 1
    SYSWRITE = 1
    SYSREAD = 0
    SYSEXIT = 60
    EXIT_SUCCESS = 0
    BUFLEN = 512

.bss
    .comm textin, 512
    .comm textout, 512


.text
    .global _start 
    _start:
    movq $SYSREAD, %rax
    movq $STDIN, %rdi
    movq $textin, %rsi
    movq $BUFLEN, %rdx
    syscall
    
    movq %rax, %r8
    dec %r8        # -'\n', potrzeba 3 znaki więc można skończyć wcześniej

    mov %r8, %rdi
    mov $textin, %rsi
    call find_abc

    cmp $-1, %rax
    mov $0, %rdi
    jne found
        movb $'-', textout(, %rdi, 1)
        inc %rdi
        movb $'1', textout(, %rdi, 1)
        inc %rdi
        jmp print

    found:
    movq $0, %r8
    movq $10, %r10	# podstawa
    movq $0, %rdx
    to_stack:
        div %r10
        add $'0', %rdx
        push %rdx
        movq $0, %rdx
        inc %r8
        cmp $0, %rax
        jg to_stack

    to_text:
        pop textout(, %rdi, 1)
        inc %rdi
        cmp %r8, %rdi
        jl to_text

    print:
    movb $'\n', textout(, %rdi, 1)

    movq $SYSWRITE, %rax
    movq $STDOUT, %rdi
    movq $textout, %rsi
    movq $BUFLEN, %rdx
    syscall
    
    movq $SYSEXIT, %rax
    movq $EXIT_SUCCESS, %rdi
    syscall


find_abc:
    mov $0, %rdx
loop:
    cmp %rdi, %rdx
    jge not_found
    mov (%rsi, %rdx, 1), %bl
    inc %rdx
    cmp $'a', %bl
    jne loop

    cmp %rdi, %rdx
    jge not_found
    mov (%rsi, %rdx, 1), %bl
    cmp $'b', %bl
    jne loop
    inc %rdx

    cmp %rdi, %rdx
    jge not_found
    mov (%rsi, %rdx, 1), %bl
    inc %rdx
    cmp $'c', %bl
    jne loop

    sub $3, %rdx
    mov %rdx, %rax
ret

    not_found:
    mov $-1, %rax
ret
