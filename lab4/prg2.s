.text
.global func
.type func, @function

func:
    mov $0, %rbx    # suma
    mov $0, %rcx    # licznik do tekstu
    mov $1, %r8 # silnia
    mov $2, %r9 # licznik do silni
convert:
    mov $0, %rax    # bufor
    movb (%rdi, %rcx, 1), %al
    cmp $'0', %al
    jl not_number
    cmp $'9', %al
    jg not_number

    sub $'0', %al

    mul %r8
    add %rax, %rbx

    mov %r8, %rax
    mul %r9
    mov %rax, %r8
    inc %r9
    inc %rcx
    cmp %rsi, %rcx
    jl convert

    mov %rbx, %rax  # returns in rax
ret
    not_number:
    mov $-1, %rax
ret
