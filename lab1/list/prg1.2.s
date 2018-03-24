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
.globl _start 
_start:
nop
movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

movq %rax, %r8
sub $2, %r8	#'\n', max potega = n-1
movq $0, %r9	#iterator_pov
movq $0, %rdi	#iterator_petla
movq $0, %r10	#liczba w zapisie dziesietnym
movq $7, %r11	#podstawa systemu
movq $10, %r12	#podstawa docelowego systemu
movq $0, %rbx	#wyzerowanie rejestru b
to_10:
movb textin(, %rdi, 1), %bl
cmp $'0', %bl
jl _start
cmp $'7', %bl
jge _start

sub $'0', %bl

movq $1, %rax
cmp $0, %r8
je skip_pov
call pov

skip_pov:
mul %rbx
add %rax, %r10

inc %rdi
dec %r8
cmp $0, %r8
jge to_10

dec %rdi
movq %rdi, %r8
movq %r10, %rax

to_char:
div %r12
add $'0', %rdx
push %rdx
movq $0, %rdx
dec %rdi
cmp $0, %rdi
jge to_char

movq $0, %rdi

to_text:
pop textout(, %rdi, 1)
inc %rdi
cmp %r8, %rdi
jle to_text

movb $'\n', textout(, %rdi, 1)

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

pov:
mul %r11
inc %r9
cmp %r8, %r9
jl pov
movq $0, %r9
ret








