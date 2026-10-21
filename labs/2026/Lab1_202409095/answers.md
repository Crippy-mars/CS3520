### Step 4- Assembly to Machine Code

| Instruction | Format | opcode | funct3 / funct7 | rd, rs1, rs2 | Hex |
|---|---|---|---|---|---|
| add t4, t1, t2 | R-type | 0110011 | funct3 = 000, funct7 = 0000000 | rd = x29, rs1 = x6, rs2 = x7 | 0x00730EB3 |
| slli t4, t4, 3 | I-type | 0010011 | funct3 = 001 | rd = x29, rs1 = x29, imm = 000000000011 | 0x003E9E93 |
| lw t1, 0(t0) | I-type | 0000011 | funct3 = 010 | rd = x6, rs1 = x5, imm = 000000000000 | 0x0002A303 |

### Step 5- Machine code to Assembly

1. 0x00A00293

000000001010 00000 000 00101 0010011

opcode = 0010011 → I-type

imm = 000000001010 = 10
rs1 = 00000 = x0
funct3 = 000
rd = 00101 = x5

Therefore:

addi x5, x0, 10

or

addi t0, zero, 10


2. 0x406283B3

0100000 00110 00101 000 00111 0110011

opcode = 0110011 → R-type

funct7 = 0100000
rs2 = 00110 = x6
rs1 = 00101 = x5
funct3 = 000
rd = 00111 = x7

Therefore:

sub x7, x5, x6

or

sub t2, t0, t1


3. 0x00329293

000000000011 00101 001 00101 0010011

opcode = 0010011 → I-type

imm = 000000000011
rs1 = 00101 = x5
funct3 = 001
rd = 00101 = x5

The shift amount is 3.

Therefore:

slli x5, x5, 3

or

slli t0, t0, 3

## Step 6 — Analyse and Extend an Example from the Repository

The `.data` section stores the strings used by the program. `la a0, hello` loads the address of the string into `a0` so that it can be used by the environment call. `a7` is loaded with 4 when the program wants to prints a string, and later loaded with 10 when the program wants to exit. I also added a second message and a small calculation, 5 + 3, then printed the result.

## Step 7 — Stretch Task: A First Look at Control Flow (Optional)

I attempted Step 7 and implemented the branch logic in `task-stretch.s`.
The program evaluates `(a + b) * 8 - c` and tests whether the result is positive using `slt t5, zero, t4` and `beq`:
- When `a = 7`, `b = 5`, `c = 20`, the result is `76` (positive), so it prints `76` and `"Result is positive."`.
- When tested with `c = 100`, the result is `-4` (not positive), jumping to label `not_positive` and printing `-4` and `"Result is not positive."`.
Both execution paths were verified.
