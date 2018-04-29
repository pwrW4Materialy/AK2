#include <stdio.h>

extern long func(char*, int);

int main(void)
{
    int length = 3;
    long res1;
    char text[] = "123";
    asm("mov $0, %%rax;\
        mov $0, %%r9;\
        mov $7, %%rcx;\
    to_number:;\
        movb (%%rdi, %%r9, 1), %%bl;\
        cmp $'0', %%bl;\
        jl not_number;\
        cmp $'6', %%bl;\
        jg not_number;\
        sub $'0', %%bl;\
        mul %%rcx;\
        add %%rbx, %%rax;\
        inc %%r9;\
        cmp %%rsi, %%r9;\
        jl to_number;\
        jmp number;\
        not_number:;\
        mov $0, %%rax;\
        number:"
        :"=a"(res1)
        :"D"(text), "S"(length)
    );
    long res2 = func(text,length);
    printf("Inline:%ld\nExtern:%ld\n",res1, res2);
}