# CS3520 - Lab 2, Exercise 1: print the larger of two integers.
# RISC-V translation of model.cpp.
#
# Demonstrates: two values held in the .data section, and a conditional
# branch that chooses between them.

        .data
a:      .word   17
b:      .word   42
msg:    .asciz  "Larger: "

        .text
main:
        lw      t0, a                   # t0 = a
        lw      t1, b                   # t1 = b

        mv      s0, t0                  # assume a is the larger value
        bge     t0, t1, show            # if a >= b that assumption holds
        mv      s0, t1                  # otherwise b is the larger value

show:
        la      a0, msg                 # print "Larger: "
        li      a7, 4
        ecall

        mv      a0, s0                  # print the larger value
        li      a7, 1
        ecall

        li      a7, 10                  # exit cleanly
        ecall
