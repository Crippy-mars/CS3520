# CS3520 - Lab 2, Exercise 2: sum the first N integers.
# RISC-V translation of model.cpp.
#
# Demonstrates: a counted loop whose exit test is the inversion of the
# C++ condition, as in examples/2026/array-max/array-max.s.

        .data
n:      .word   10
msg:    .asciz  "Sum: "

        .text
main:
        lw      t0, n                   # t0 = N
        li      t1, 1                   # t1 = i, the next number to add
        li      t2, 0                   # t2 = sum

loop:
        bgt     t1, t0, done            # leave once i > N
        add     t2, t2, t1              # sum += i
        addi    t1, t1, 1               # i++
        j       loop                    # repeat

done:
        la      a0, msg                 # print "Sum: "
        li      a7, 4
        ecall

        mv      a0, t2                  # print the sum
        li      a7, 1
        ecall

        li      a7, 10                  # exit cleanly
        ecall
