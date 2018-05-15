#include <stdio.h>

extern double lnApprox(double, int);

int main(void){
    double x;
    int steps;
    printf("x from (-1,1]:");
    scanf("%lf", &x);
    printf("Steps:");
    scanf("%d", &steps);

    double res = lnApprox(x,steps);
    printf("ln(1+%lf) approximation: %lf\n", x, res);
}