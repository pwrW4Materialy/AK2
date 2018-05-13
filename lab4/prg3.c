/**
 * Wywołanie funkcji napisanej w jęz. asemblera.
 * Funkcja obliczająca wartość liczby danej w zapisie tekstowym w reprezentacji,
 * w której wagami pozycji są kolejne wartości silni (mniejsze wagi dla bardziej znaczących cyfr).
 **/

#include <stdio.h>

extern long func(char*, int);

int main(void)
{
    int length = 3;
    char text[] = "123";
    long res = func(text,length);
    printf("Result:%ld\n",res);
}