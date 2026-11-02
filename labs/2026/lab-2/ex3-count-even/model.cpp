// CS3520 - Lab 2, Exercise 3: count the even elements of an array.
// C++ model. Written first, tested, then translated to RISC-V assembly.

#include <iostream>

int main()
{
    int array[] = {8, 13, 22, 35, 40, 57, 64, 79, 96, 11};
    int n = 10;
    int count = 0;

    for (int i = 0; i < n; i++) {
        if ((array[i] & 1) == 0) {   // low bit clear means even
            count++;
        }
    }

    std::cout << "Even count: " << count << std::endl;
    return 0;
}
