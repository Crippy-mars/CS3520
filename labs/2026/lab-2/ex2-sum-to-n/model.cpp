// CS3520 - Lab 2, Exercise 2: sum the first N integers.
// C++ model. Written first, tested, then translated to RISC-V assembly.

#include <iostream>

int main()
{
    int n = 10;
    int sum = 0;

    for (int i = 1; i <= n; i++) {
        sum += i;        // add 1, then 2, ... up to n
    }

    std::cout << "Sum: " << sum << std::endl;
    return 0;
}
