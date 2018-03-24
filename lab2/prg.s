# Wczytanie 2 liczb z plików, potraktorwanie jako liczby w zapisie szesnastkowym,
# dodanie obu liczb i wypisanie wyniku w kodzie czwórkowym do pliku.
.data
    SYSEXIT = 60
    EXIT_SUCCESS = 0
    SYSREAD = 0
    SYSWRITE = 1
    STDOUT = 1
    SYSOPEN = 2
    SYSCLOSE = 3
    O_RDONLY = 00
    O_WRONLY = 01
    O_WR_CRT_TRNC = 01101

    BUFLEN = 1024

    f_in1: .ascii "in1\0"
    f_in2: .ascii "in2\0"
    f_out: .ascii "out\0"

.bss
    .comm num1_buf, 1024
    .comm num1, 1024
    .comm num2_buf, 1024
    .comm num2, 1024
    .comm sum_buf, 1024
    .comm sum_out, 1024

.text
    .globl _start
    _start:

    num1_file:              # %r14 - number of num1 bytes
        movq $SYSOPEN, %rax
        movq $f_in1, %rdi
        movq $O_RDONLY, %rsi
        movq $0666, %rdx
        syscall

        movq %rax, %rdi  # file handle
        movq $SYSREAD, %rax
        movq $num1_buf, %rsi
        movq $BUFLEN, %rdx
        syscall

        movq %rax, %r14  
        sub $3, %r14       # taking 2 bytes at a time

        movq $SYSCLOSE, %rax    # file handle still in %rdi
        syscall
    num2_file:              # %r15 - number of num1 bytes
        movq $SYSOPEN, %rax
        movq $f_in2, %rdi
        movq $O_RDONLY, %rsi
        movq $0666, %rdx
        syscall

        movq %rax, %rdi
        movq $SYSREAD, %rax
        movq $num2_buf, %rsi
        movq $BUFLEN, %rdx
        syscall

        movq %rax, %r15  
        sub $3, %r15

        movq $SYSCLOSE, %rax
        syscall

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
        inc %r14            # number of bytes (+1 because @45)
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
        je add_no_carry

        movq $0, %rdi
        movb num2_buf(, %rdi, 1), %al
        call to_number
        cmp $0, %ah
        jne exit
        movb %al, num2(, %rsi, 1)
        inc %r15

add_no_carry:
    movq $0, %rdi
    movq num1(, %rdi, 8), %rax
    movq num2(, %rdi, 8), %rbx
    add %rbx, %rax
    pushf
        
    add_carry:
        movq %rax, sum_buf(, %rdi, 8)
        inc %rdi
        popf
        movq num1(, %rdi, 8), %rax
        movq num2(, %rdi, 8), %rbx
        adc %rbx, %rax
        pushf
        cmp $0, %rax
        jne add_carry
    popf
    adc $0, %rax        # add carry, if %rax=ff..f+1
    cmp $0, %rax
    je no_carry
    movb $1, sum_buf(, %rdi, 8)
    inc %rdi

no_carry:
    movq %rdi, %rax
    movq $8, %r8
    mul %r8
    movq %rax, %r11         # %r11 - number of sum_buf bytes
    movq $0, %rdi
    movq $0, %r9            # to_stack iterator
    to_quater:
        movb sum_buf(, %rdi, 1), %al
        inc %rdi
        to_stack:
            movb %al, %bl
            and $3, %bl
            shr $2, %al
            add $'0', %bl
            push %rbx
            inc %r9
            cmp $4, %r9
            jl to_stack

        movq $0, %r9
        cmp %r11, %rdi
        jl to_quater

    movq %r11, %rax     # n of bytes *4 
    movq $4, %r8
    mul %r8
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
        movb %bl, sum_out(, %rdi, 1)
        inc %rdi
        cmp %rax, %rdi
        jl to_text
    movq %rdi, %r9

    movq $SYSOPEN, %rax
    movq $f_out, %rdi
    movq $O_WR_CRT_TRNC, %rsi
    movq $0666, %rdx
    syscall

    movq %rax, %rdi  # file handle
    movq $SYSWRITE, %rax
    movq $sum_out, %rsi
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
