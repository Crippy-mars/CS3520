# CS3520 - Lab 2: Assembly Programming II

Control flow, procedures and the stack. Each exercise is self-contained and
holds a tested C++ model, a hand-written RISC-V translation, and short notes.

| Folder | Problem | Printed result |
|---|---|---|
| [`ex1-larger-of-two/`](ex1-larger-of-two/) | larger of two integers in `.data` | `Larger: 42` |
| [`ex2-sum-to-n/`](ex2-sum-to-n/) | sum of the first N integers | `Sum: 55` |
| [`ex3-count-even/`](ex3-count-even/) | count even elements of an array | `Even count: 5` |
| [`ex4-factorial/`](ex4-factorial/) | factorial computed by a procedure | `10! = 3628800` |
| [`ex5-gcd/`](ex5-gcd/) | gcd by Euclid, as a procedure | `gcd(1071, 462) = 21` |
| [`ex5-stretch-gcd-recursive/`](ex5-stretch-gcd-recursive/) | the stretch: recursive gcd | `gcd(1071, 462) = 21` |

Only base RV32I instructions are used. In particular there is no `mul` and no
`rem`: `factorial` multiplies by repeated addition and both gcd versions take
the remainder by repeated subtraction, which is one of the two forms the
handout allows.

## Step 2 - the worked example

### Why the C++ test `i < n` becomes `bge i, n, exit`

A C++ loop condition answers "should the body run?". A RISC-V branch answers
"should control go somewhere else?". The natural assembly shape is

```text
loop:
        b<exit condition>   done
        ... body ...
        j                   loop
done:
```

so the branch at the top is the one that *leaves* the loop, and it must test
the negation of the C++ condition. `i < n` keeps looping, so the branch tests
`i >= n`.

This is not a hardware restriction - `blt` exists and could branch back into
the body - but using it that way needs a second, unconditional branch to skip
the body on the first test. Inverting the test leaves one branch per iteration
and puts the taken path at the loop exit, where it is paid once. The example
uses `bge`; Exercises 2 and 3 use the same shape.

### What the pseudo-instructions become

| Source | Real instructions | Example from this lab |
|---|---|---|
| `li rd, imm` | `addi rd, x0, imm` if the constant fits in 12 bits, otherwise `lui` + `addi` | `li a7, 4` is `0x00400893`, i.e. `addi a7, x0, 4` |
| `mv rd, rs` | `addi rd, rs, 0` | `mv s0, t0` is `0x00028413`, i.e. `addi s0, t0, 0` |
| `la rd, label` | `auipc rd, hi20` + `addi rd, rd, lo12`, both relative to the PC | `la a0, msg` at `0x1C` is `auipc a0, 0x10000` (`0x10000517`) followed by `addi a0, a0, -20` (`0xFEC50513`) |
| `ble rs1, rs2, label` | `bge rs2, rs1, label` - the operands are swapped | `ble t4, s1, skip` in the worked example is `0x01D4D463`, which decodes as `bge s1, t4, skip` |
| `bgt rs1, rs2, label` | `blt rs2, rs1, label` | used in Exercise 2's loop |
| `j label` | `jal x0, label` | used at the bottom of every loop here |
| `nop` | `addi x0, x0, 0` | the Lab 3 sources use it as pipeline padding |

The assembler provides them because the ISA encodes exactly one operation in
each 32-bit word. A pseudo-instruction is source-level sugar: it lets the
programmer write the intent (`mv`, `la`, `ble`) and lets the assembler choose
the encoding that fits - `li` above has to choose between a one-word and a
two-word expansion depending on the constant. The processor never sees a
pseudo-instruction, which is also why the instruction count in Ripes is higher
than the number of source lines.

### Why `find_max` saves `s1` but not `ra`

`s1` is **callee-saved**. The calling convention promises that a procedure
leaves `s0`-`s11` as it found them, so if `find_max` wants to use `s1` it must
save the caller's value on the stack and restore it before returning. That is
the `addi sp, sp, -4` / `sw s1, 0(sp)` / `lw s1, 0(sp)` / `addi sp, sp, 4`
pair.

`ra` is different. A procedure only destroys `ra` if it makes another call,
because `jal` writes the return address into it. `find_max` is a **leaf**: it
calls nothing, so the `ra` it was entered with is still the address of the
instruction after the `jal` in `main`. Saving it would only copy a value that
is already correct. The recursive gcd in the stretch is not a leaf, and it
does exactly what `find_max` omits: it saves `ra` in every activation.

## Running the work

Test a model:

```bash
g++ -Wall -std=c++17 model.cpp -o model
./model
```

Run the assembly in Ripes: load `solution.s`, assemble it, and run. Ripes puts
`.text` at `0x00000000` and `.data` at `0x10000000`; `ecall` with `a7 = 4`
prints a string, `a7 = 1` prints an integer, and `a7 = 10` exits.

Each `notes.md` lists the register map for that exercise, so the programs can
be followed while single-stepping.

Step 5's instruction-format work is in
[`encoding-analysis.md`](encoding-analysis.md).
