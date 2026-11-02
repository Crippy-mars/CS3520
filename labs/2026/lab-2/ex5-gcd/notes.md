# Exercise 5 - greatest common divisor by Euclid

`solution.s` puts `a` and `b` into `a0` and `a1`, calls `gcd`, and prints
`gcd(1071, 462) = 21`.

## Registers

| Register | Holds |
|---|---|
| `a0` | first argument, then the current `a`, then the result |
| `a1` | second argument, then the current `b` |
| `t0` | temporary used by the swap |
| `s0` in `main` | the returned gcd, kept while printing |
| `ra` | return address |

## Notes

RV32I has no `rem` instruction, so the remainder is taken by repeated
subtraction, which the handout allows. One pass of the loop does:

```text
if (b == 0) stop          -> beq a1, zero, done
if (a >= b) skip the swap -> bge a0, a1, subtract
otherwise swap a and b    -> three mv instructions
a = a - b                 -> sub a0, a0, a1
```

The swap matters: without it, subtracting a larger `b` from a smaller `a` would
make `a` negative and the algorithm would never finish. Keeping `a >= b` before
every subtraction is the invariant that makes the loop terminate.

`gcd` is a leaf procedure and uses only argument and temporary registers, so it
has no stack frame at all. It needs `ra` only to return, and no callee-saved
register is touched.

The recursive version in [`../ex5-stretch-gcd-recursive/`](../ex5-stretch-gcd-recursive/)
is the same algorithm with the loop replaced by a call to itself.
