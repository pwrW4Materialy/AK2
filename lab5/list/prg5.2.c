#include <stdio.h>

extern double sinusApprox(double, int);

int main(void){
    double deg;
    int steps;
    printf("Degree (rad):");
    scanf("%lf", &deg);
    printf("Steps:");
    scanf("%d", &steps);

    double res = sinusApprox(deg,steps);
    printf("Sin(%lf) approximation: %lf\n", deg, res);
}