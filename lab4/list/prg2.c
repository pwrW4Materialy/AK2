#include <stdio.h>

const int  n = 20;

int main(void)
{
    int zmienna1 = 2, zmienna2 = 3, wynik;
    asm("add %2, %1;\
        add $1, %1;\
        add n, %1;"        
        : "=a" (wynik)
        : "a" (zmienna1), "b" (zmienna2)
    );

    printf("%d\n", wynik);
}