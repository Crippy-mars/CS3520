# Exercise 2 - sum of the first N integers

`solution.s` reads `N` from `.data`, adds the integers `1` to `N` in a counted
loop, and prints `Sum: ` followed by the total.

## Registers

| Register | Holds |
|---|---|
| `t0` | `N`, the last number to add |
| `t1` | `i`, the next number to add |
| `t2` | the running total |
| `a0`, `a7` | `ecall` argument and call number |

## Notes

The model says `for (i = 1; i <= n; i++)`. The assembly has to decide when to
*leave*, so the test is the inversion: `bgt t1, t0, done` exits once `i > N`.
That keeps the loop body on the fall-through path and puts the single taken
branch at the bottom of the body.

`bgt` is a pseudo-instruction: the assembler emits `blt t0, t1, done`, with the
operands swapped, because there is no "branch if greater than" in the encoding.
`j loop` is also a pseudo and becomes `jal zero, loop`.

N = 10, so the loop adds 1 through 10 and prints `Sum: 55`.
