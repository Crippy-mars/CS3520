# CS3520 - Lab 2, Exercise 3: count the even elements of an array.
# RISC-V translation of model.cpp.
#
# Demonstrates: array indexing, a counted loop, and andi as the bit test
# that asks whether the low bit of an element is clear.

        .data
array:  .word   8, 13, 22, 35, 40, 57, 64, 79, 96, 11
n:      .word   10
msg:    .asciz  "Even count: "

        .text
main:
        la      s0, array               # s0 = base address of the array
        lw      s1, n                   # s1 = number of elements
        li      s2, 0                   # s2 = how many elements are even
        li      t0, 0                   # t0 = i

loop:
        bge     t0, s1, done            # leave once i >= n
        slli    t1, t0, 2               # t1 = i * 4, the byte offset
        add     t1, s0, t1              # t1 = address of array[i]
        lw      t2, 0(t1)               # t2 = array[i]
        andi    t2, t2, 1               # keep only the low bit
        bne     t2, zero, next          # odd, so do not count it
        addi    s2, s2, 1               # even, so count it

next:
        addi    t0, t0, 1               # i++
        j       loop                    # repeat

done:
        la      a0, msg                 # print "Even count: "
        li      a7, 4
        ecall

        mv      a0, s2                  # print the count
        li      a7, 1
        ecall

        li      a7, 10                  # exit cleanly
        ecall
