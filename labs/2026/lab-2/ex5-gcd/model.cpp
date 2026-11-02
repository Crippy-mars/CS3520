// CS3520 - Lab 2, Exercise 5: greatest common divisor by Euclid's algorithm.
// C++ model. Written first, tested, then translated to RISC-V assembly.
//
// The remainder is taken by repeated subtraction rather than with the %
// operator, so that the assembly can stay inside base RV32I. RV32I has no
// remainder instruction; rem belongs to the M extension.

#include <iostream>

int gcd(int a, int b)
{
    while (b != 0) {
        if (a < b) {          // keep a >= b before subtracting
            int t = a;
            a = b;
            b = t;
        }
        a = a - b;
    }
    return a;
}

int main()
{
    int a = 1071;
    int b = 462;
    std::cout << "gcd(" << a << ", " << b << ") = " << gcd(a, b) << std::endl;
    return 0;
}
