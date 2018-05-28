#include <stdio.h>

extern int getPrecision();
extern void setPrecision(int);

int main(void){
    int choice, precision;
    do{
        printf("1. Check precision\n2. Set precision\n0. Exit\n>");
        scanf("%d", &choice);

        if (choice == 1){
            precision = getPrecision();
            switch (precision){
                case 0:
                    printf("Current precision: single\n");
                    break;
                case 2:
                    printf("Current precision: double\n");
                    break;
                case 3:
                    printf("Current precision: extended double\n");
                    break;
                default:
                    break;
            }
        }

        else if (choice == 2){
            printf("Choose precision:\n 0. Single\n 2. Double\n 3. Extended double\n>");
            scanf("%d", &precision);
            if (precision > 3 || precision == 1){
                printf("Wrong argument!\n");
                continue;
            }
            setPrecision(precision);
        }

    } while(choice != 0);
}