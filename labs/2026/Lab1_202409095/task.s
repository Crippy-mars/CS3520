.data
a:      .word 7
b:      .word 5
c:      .word 20

.text
main:
    # Load a, b and c from memory
    la t0, a
    lw t1, 0(t0)        # t1 = a

    la t0, b
    lw t2, 0(t0)        # t2 = b

    la t0, c
    lw t3, 0(t0)        # t3 = c

    # result = (a + b) * 8 - c
    add t4, t1, t2      # t4 = a + b
    slli t4, t4, 3      # t4 = (a + b) * 8
    sub t4, t4, t3      # t4 = result

    # Print the integer result
    mv a0, t4
    addi a7, zero, 1
    ecall

    # Exit
    addi a7, zero, 10
    ecall