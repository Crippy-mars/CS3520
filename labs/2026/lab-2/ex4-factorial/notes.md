# Exercise 4 - factorial, computed by a procedure

`main` puts `n` in `a0`, calls `factorial` with `jal`, keeps the result, and
prints `10! = 3628800`. `factorial` returns through `jalr zero, ra, 0`.

## Registers

| Register | Holds |
|---|---|
| `a0` | argument `n` on the way in, result `n!` on the way out |
| `s0` | the running product (callee-saved, so it is saved on the stack) |
| `t0` | `i`, the next factor |
| `t1`, `t2` | counter and partial product for the repeated addition |
| `s0` in `main` | the returned value, kept while printing |
| `ra`, `sp` | return address and stack pointer |

## Stack frame

```text
sp + 4 : (unused, keeps sp 8-byte aligned)
sp + 0 : saved s0
```

## Notes

Two things were harder than expected.

First, RV32I has no multiply instruction. `mul` is part of the M extension, so
`result *= i` is written as a small inner loop that adds `result` to itself `i`
times. That is slower but stays inside the base instruction set the course has
used so far.

Second, the procedure uses `s0`, which is callee-saved: `factorial` must
restore whatever `s0` the caller had, so it saves it on the stack at the top and
restores it before returning. It does **not** save `ra`, because it makes no
calls of its own. That is the same distinction the worked example makes for
`find_max`: a leaf procedure's `ra` is still valid, a non-leaf procedure's is
not. Exercise 5's stretch makes exactly that point.
