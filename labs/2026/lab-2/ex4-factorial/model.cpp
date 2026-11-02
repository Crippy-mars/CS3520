// CS3520 - Lab 2, Exercise 4: factorial, computed by a procedure.
// C++ model. Written first, tested, then translated to RISC-V assembly.

#include <iostream>

int factorial(int n)
{
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

int main()
{
    int n = 10;
    std::cout << n << "! = " << factorial(n) << std::endl;
    return 0;
}
