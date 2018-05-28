 .data

.text
.global Filter_sub, Filter_xor, Filter_xor_mmx, get_cycles
.type Filter_sub, @function
.type Filter_xor, @function
.type Filter_xor_mmx, @function
.type get_cycles, @function


Filter_sub:
	push %rbp
	mov %rsp, %rbp

	mov %rdx, %rax
	mul %rcx
	mov %rax, %r9	# width*height
	mov $0, %r8	    # iterator

loop_sub:
	mov $0x00FFFFFF, %ecx
	movd %ecx, %mm0

	movl (%rdi,%r8,1), %ecx
	movd %ecx, %mm1

	psubb %mm1, %mm0
	
	movd %mm0, %ecx

	movl %ecx, (%rsi,%r8,1)

	inc %r8
	cmp %r9, %r8
	jl loop_sub

	mov %rbp, %rsp
	pop %rbp
ret

Filter_xor_mmx:
	push %rbp
	mov %rsp, %rbp

	mov %rdx, %rax
	mul %rcx
	mov %rax, %r9	# width*height
	mov $0, %r8	    # iterator

	mov $0x00FFFFFF, %ecx
	movd %ecx, %mm0

loop_xm:
	movl (%rdi,%r8,1), %ecx
	movd %ecx, %mm1

	pxor %mm0, %mm1
	
	movd %mm1, %ecx

	movl %ecx, (%rsi,%r8,1)

	inc %r8
	cmp %r9, %r8
	jl loop_xm

	mov %rbp, %rsp
	pop %rbp
ret

Filter_xor:
	push %rbp
	mov %rsp, %rbp

	mov %rdx, %rax
	mul %rcx
	mov %rax, %r9	# width*height
	mov $0, %r8	    # iterator

	mov $0x00FFFFFF, %ecx

loop_x:
	movl (%rdi,%r8,1), %ebx

    xor %ecx, %ebx

	movl %ebx, (%rsi,%r8,1)

	inc %r8
	cmp %r9, %r8
	jl loop_x

	mov %rbp, %rsp
	pop %rbp
ret

get_cycles:
	push %rbp
	mov %rsp, %rbp

	xor %rax, %rax
	rdtscp
	
	mov %rbp, %rsp
	pop %rbp
ret
