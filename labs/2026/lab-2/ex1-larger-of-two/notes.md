# Exercise 1 - larger of two integers

`solution.s` loads `a` and `b` from `.data`, keeps the larger one in `s0`, and
prints `Larger: ` followed by that value with the same `ecall` calls the worked
example uses.

## Registers

| Register | Holds |
|---|---|
| `t0` | `a`, the first value |
| `t1` | `b`, the second value |
| `s0` | the answer, kept out of the way while printing |
| `a0`, `a7` | `ecall` argument and call number |

## Notes

The C++ test is `if (b > a)`, and the assembly inverts it: `bge t0, t1, show`
falls through when `a` is already the larger value and jumps only when `b`
wins. Writing it that way means the common case needs no extra jump, which is
the same reasoning behind the `bge` exit test in
`examples/2026/array-max/array-max.s`.

`bge` is a real B-type instruction, not a pseudo-instruction, so it is the
branch taken apart in [`../encoding-analysis.md`](../encoding-analysis.md).

The data is `a = 17`, `b = 42`, so the output is `Larger: 42` and the branch is
**not** taken: `17 >= 42` is false, so control falls through to `mv s0, t1`.
Swapping the two `.word` values to `a = 42`, `b = 17` makes the branch taken; I
checked both paths by hand-editing the data and re-running.
