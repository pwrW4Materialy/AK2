#include <stdio.h>

int main(void)
{
    int zmienna1 = 2, zmienna2 = 3, wynik;
    char text[] = "12";
    asm("mov $0, %%eax;\
        add %2, %1;\
        add $1, %1;\
        cmp $10, %%eax;\
        jge label;\
        mov $0, %%rax;\
        movb (%3, %%rax,1), %%al;\
        label:"       
        : "=a" (wynik)
        : "a" (zmienna1), "b" (zmienna2), "r"(&text)
    );

    printf("%d\n", wynik);
}