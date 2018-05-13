/**
 * Wstawka w języku asemblera obliczająca wartość liczby danej za pomocą łańcucha znaków w reprezentacji siódemkowej,
 * np. "14352" i zapisanie wyniku w zmiennej globalnej w jęz. C. Można również przekazać długość.
 **/

#include <stdio.h>

int main(void)
{
    int length = 3;
    long res;
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
        :"=a"(res)
        :"D"(text), "S"(length)
    );
    printf("Result:%ld\n",res);
}