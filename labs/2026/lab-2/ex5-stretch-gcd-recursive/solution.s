# CS3520 - Lab 2, stretch: greatest common divisor, recursively.
# RISC-V translation of model.cpp.
#
# The same subtractive Euclid as Exercise 5, but gcd calls itself instead
# of looping. It is therefore no longer a leaf procedure: the nested jal
# overwrites ra with a new return address, so each activation must save
# the ra it was given. Without that saved copy the outer call could never
# find its way back to main.

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
# if (b == 0) return a;
# if (a < b) swap(a, b);
# return gcd(a - b, b);
#
# Non-leaf, so the frame holds ra. The arguments are in caller-saved
# registers, so they do not need to be saved: a0 and a1 are set up for
# the call and a0 carries the result back.
# ---------------------------------------------------------------
gcd:
        beq     a1, zero, base          # gcd(a, 0) = a
        bge     a0, a1, ordered         # keep a >= b before subtracting
        mv      t0, a0                  # swap a and b
        mv      a0, a1
        mv      a1, t0

ordered:
        sub     a0, a0, a1              # first argument of the recursive call: a - b
        addi    sp, sp, -8              # frame for this activation
        sw      ra, 4(sp)               # save the return address it was given
        jal     ra, gcd                 # gcd(a - b, b)
        lw      ra, 4(sp)               # restore our own return address
        addi    sp, sp, 8               # release the frame

base:
        jalr    zero, ra, 0             # return a0
