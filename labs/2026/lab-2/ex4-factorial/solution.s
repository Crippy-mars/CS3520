# CS3520 - Lab 2, Exercise 4: factorial, computed by a procedure.
# RISC-V translation of model.cpp.
#
# Demonstrates: jal and jalr, the argument register a0, the return register
# a0, and a callee-saved register preserved on the stack.
#
# RV32I has no multiply instruction, so result *= i is written as a
# repeated-addition loop. That keeps the program inside the base ISA.

        .data
n:      .word   10
msg:    .asciz  "! = "

        .text
main:
        lw      a0, n                   # argument: n
        jal     ra, factorial           # call factorial(n); result in a0
        mv      s0, a0                  # keep the result safe while printing

        lw      a0, n                   # print n
        li      a7, 1
        ecall

        la      a0, msg                 # print "! = "
        li      a7, 4
        ecall

        mv      a0, s0                  # print the factorial
        li      a7, 1
        ecall

        li      a7, 10                  # exit cleanly
        ecall

# ---------------------------------------------------------------
# factorial(n in a0) -> n! in a0
#
# The running product lives in s0, so this procedure has to preserve the
# caller's s0. It makes no calls of its own, so it is a leaf procedure
# and ra is still the return address main gave it: ra does not need to be
# saved.
# ---------------------------------------------------------------
factorial:
        addi    sp, sp, -8              # one word for s0, one to keep sp aligned
        sw      s0, 0(sp)               # preserve the caller's s0

        li      s0, 1                   # s0 = result, starting at 1
        li      t0, 2                   # t0 = i, starting at 2

outer:
        bgt     t0, a0, done            # leave once i > n
        li      t1, 0                   # t1 = how many copies of result we have added
        li      t2, 0                   # t2 = result * i, built by repeated addition

inner:
        bge     t1, t0, multiplied      # leave once i copies have been added
        add     t2, t2, s0              # t2 += result
        addi    t1, t1, 1               # one more copy added
        j       inner

multiplied:
        mv      s0, t2                  # result = result * i
        addi    t0, t0, 1               # i++
        j       outer

done:
        mv      a0, s0                  # return the result in a0
        lw      s0, 0(sp)               # restore the caller's s0
        addi    sp, sp, 8               # release the stack frame
        jalr    zero, ra, 0             # return to main
