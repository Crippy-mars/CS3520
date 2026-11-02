# CS3520 - Lab 2, Exercise 5: greatest common divisor by Euclid's algorithm.
# RISC-V translation of model.cpp.
#
# Demonstrates: a procedure containing a loop, and repeated subtraction in
# place of a remainder instruction. RV32I has no rem; rem belongs to the M
# extension, so the subtraction form was used for both model and assembly.

        .data
a:      .word   1071
b:      .word   462
open:   .asciz  "gcd("
comma:  .asciz  ", "
close:  .asciz  ") = "

        .text
main:
        lw      a0, a                   # first argument
        lw      a1, b                   # second argument
        jal     ra, gcd                 # call gcd(a, b); result in a0
        mv      s0, a0                  # keep the result safe while printing

        la      a0, open                # print "gcd("
        li      a7, 4
        ecall

        lw      a0, a                   # print a
        li      a7, 1
        ecall

        la      a0, comma               # print ", "
        li      a7, 4
        ecall

        lw      a0, b                   # print b
        li      a7, 1
        ecall

        la      a0, close               # print ") = "
        li      a7, 4
        ecall

        mv      a0, s0                  # print the gcd
        li      a7, 1
        ecall

        li      a7, 10                  # exit cleanly
        ecall

# ---------------------------------------------------------------
# gcd(a in a0, b in a1) -> gcd in a0
#
# while (b != 0) { if (a < b) swap(a, b); a = a - b; }
#
# Leaf procedure: it touches only a- and t-registers, so there is nothing
# to save on the stack. a0 holds the result on the way out.
# ---------------------------------------------------------------
gcd:
        beq     a1, zero, done          # gcd(a, 0) = a
        bge     a0, a1, subtract        # already in order, no swap needed
        mv      t0, a0                  # swap a and b so that a >= b
        mv      a0, a1
        mv      a1, t0

subtract:
        sub     a0, a0, a1              # a = a - b
        j       gcd                     # and go round again

done:
        jalr    zero, ra, 0             # return a0
