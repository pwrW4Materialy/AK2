#include <stdio.h>
#include <math.h>

extern int checkExc();
extern void clrMasks();
extern void maskExc(int);
extern void testDivByZero();

int main(void){
    int choice, exceptions;
    do{
        printf("1. Check exceptions\n"
                "2. Mask exceptions\n"
                "3. Clear all masks\n"
                "4. Divide by zero test\n0. Exit\n>");
        scanf("%d", &choice);

        if (choice == 1){
            exceptions = checkExc();
            if (exceptions == 0){
                printf("No exceptions are set\n");
                continue;
            }
            if (exceptions % 2 == 1)    // bit 0
                printf("Invalid-Operation Exception\n");
            
            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 1
                printf("Denormalized-Operand Exception\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 2
                printf("Zero-Divide Exception\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 3
                printf("Overflow Exception Exception\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 4
                printf("Underflow Exception Exception\n");

            exceptions = exceptions >> 1;
            if (exceptions % 2 == 1)    // bit 5
                printf("Precision Exception Exception\n");
        }

        else if (choice == 2){
            printf("Choose exception to mask:\n"
            "0. Invalid-Operation Exception\n"
            "1. Denormalized-Operand Exception\n"
            "2. Zero-Divide Exception\n"
            "3. Overflow Exception\n"
            "4. Underflow Exception\n"
            "5. Precision Exception\n>");
            scanf("%d", &exceptions);
            if (exceptions > 5 || exceptions < 0){
                printf("Wrong argument!\n");
                continue;
            }

            maskExc((int)pow(2,exceptions)); // to get correct bits set
        }

        else if (choice == 3){
            clrMasks();
        }

        else if (choice == 4){
            testDivByZero();
        }

    } while(choice != 0);
}