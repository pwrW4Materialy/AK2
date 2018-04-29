#include <stdio.h>

extern int func(int arg1, float arg2);

int main(void)
{
    int a1 = 4, res;
    float a2 = 2.5;
    res = func(a1, a2);
    printf("%d\n", res);
}