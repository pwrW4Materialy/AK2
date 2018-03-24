# Obliczenie wyniku funkcji rekurencyjnej:
# func(n){
#   if (n==0) return 3;
#   if (n==1) return 1;
# return func(n-2)-5*func(n-1);}
# n zadawane z klawiatury, wynik na standardowe wyjście,
# funkcja przekazująca argumenty przez rejestry
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
    .comm textin, BUFLEN
    .comm textout, BUFLEN

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

    num1_decode:
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
        jl num1_decode

    movq %rax, %r8

    call func
    mov %r9, %rax
    mov $0, %rdi
    mov $0, %r8
    cmp $0, %rax
    jge positive
        movb $'-', textout(, %rdi, 1)
        inc %rdi
        mov $-1, %r9
        mul %r9
        inc %r8
    positive:
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


func:
    push %rbp
    mov %rsp, %rbp
    sub $16, %rsp
    mov %r8, -8(%rbp)   # preserve %r8 (n)
    mov %r10, -16(%rbp)   # preserve %r10 (temp result of 5f(n-1))
        cmp $0, %r8
        je is0
        cmp $1, %r8
        je is1

        dec %r8
        call func       # returns in %r9
        mov $5, %rax  
        mul %r9
        mov %rax, %r10  # %r10 = 5f(n-1)
        
        dec %r8
        call func       # %r9 = f(n-2)
        
        sub %r10, %r9
        jmp end
    is0:
        movq $3, %r9
        jmp end
    is1:
        movq $1, %r9 
    end:
    mov -8(%rbp), %r8    # restore %r8
    mov -16(%rbp), %r10  # restore %r10
    mov %rbp, %rsp
    pop %rbp
ret
