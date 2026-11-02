// CS3520 - Lab 2, stretch: greatest common divisor, recursively.
// C++ model. Written first, tested, then translated to RISC-V assembly.
//
// Same subtractive form as Exercise 5: the swap happens before the call,
// and the subtraction is passed on as the new first argument.

#include <iostream>

int gcd(int a, int b)
{
    if (b == 0) {
        return a;
    }
    if (a < b) {
        int t = a;
        a = b;
        b = t;
    }
    return gcd(a - b, b);
}

int main()
{
    int a = 1071;
    int b = 462;
    std::cout << "gcd(" << a << ", " << b << ") = " << gcd(a, b) << std::endl;
    return 0;
}
