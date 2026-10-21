.data
hello:  .asciz "Hello world!\n"
msg2:   .asciz "This is my second message.\n"

.text
main:
    # print first message
    la a0, hello
    addi a7, zero, 4
    ecall

    # print second message
    la a0, msg2
    addi a7, zero, 4
    ecall

    # small arithmetic calculation
    addi t0, zero, 5
    addi t1, zero, 3
    add t2, t0, t1

    # print result
    add a0, t2, zero
    addi a7, zero, 1
    ecall

    # exit
    addi a7, zero, 10
    ecall