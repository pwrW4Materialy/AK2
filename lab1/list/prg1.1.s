.data
SYSEXIT = 60
SYSREAD = 0
SYSWRITE = 1
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
BUFLEN = 512

.bss
.comm textin, 512
.comm textout, 512

.text
.globl _start
_start:
nop
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

dec %rax
movq $0, %rdi

znaki_petla:
movb textin(, %rdi, 1), %bh
cmp $'0', %bh
jl inny_znak

cmp $'9', %bh
jng cyfra

cmp $'A', %bh
jl inny_znak

cmp $'Z', %bh
jng wielka_litera

jmp inny_znak

cyfra:
add $2, %bh

wielka_litera:
add $3, %bh

inny_znak:
movb %bh, textout(, %rdi, 1)
inc %rdi
cmp %rax, %rdi
jl znaki_petla

movb $'\n', textout(, %rdi, 1)

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
