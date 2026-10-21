.data
a:          .word 7
b:          .word 5
c:          .word 20

pos_msg:    .asciz "\nResult is positive.\n"
not_pos_msg:.asciz "\nResult is not positive.\n"

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

    # Step 7 Control Flow:
    # Check if result is positive (t4 > 0)
    # Using slt: if zero < t4 then t5 = 1, otherwise t5 = 0
    slt t5, zero, t4
    beq t5, zero, not_positive

    # Positive outcome
    la a0, pos_msg
    addi a7, zero, 4
    ecall
    beq zero, zero, exit

not_positive:
    # Non-positive outcome
    la a0, not_pos_msg
    addi a7, zero, 4
    ecall

exit:
    addi a7, zero, 10
    ecall
