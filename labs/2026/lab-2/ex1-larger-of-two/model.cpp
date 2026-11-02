// CS3520 - Lab 2, Exercise 1: print the larger of two integers.
// C++ model. Written first, tested, then translated to RISC-V assembly.

#include <iostream>

int main()
{
    int a = 17;
    int b = 42;

    int larger = a;      // assume the first value is the larger one
    if (b > a) {         // correct the assumption if it is wrong
        larger = b;
    }

    std::cout << "Larger: " << larger << std::endl;
    return 0;
}
