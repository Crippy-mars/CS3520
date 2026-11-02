# Stretch - recursive gcd

The same subtractive Euclid as Exercise 5, written as a self-calling procedure:

```text
if (b == 0) return a;
if (a < b) swap(a, b);
return gcd(a - b, b);
```

`main` is the same as in Exercise 5 and prints `gcd(1071, 462) = 21`.

## Registers

| Register | Holds |
|---|---|
| `a0` | first argument, then the recursive call's argument, then the result |
| `a1` | second argument, unchanged across the call |
| `t0` | temporary used by the swap |
| `ra` | the return address for *this* activation |
| `sp` | base of the activation's frame |

## Notes - what changes when a procedure stops being a leaf

In Exercise 5, `gcd` never calls anything, so the `ra` it was entered with is
still the address to return to. It can return with a single `jalr zero, ra, 0`
and needs no stack.

Here `gcd` calls `gcd`. The nested `jal` overwrites `ra` with the address to
come back to *inside* the procedure, destroying the address it needs to get
back to its own caller. Every activation therefore has to save `ra` before the
call and restore it afterwards:

```text
addi sp, sp, -8
sw   ra, 4(sp)
jal  ra, gcd
lw   ra, 4(sp)
addi sp, sp, 8
```

The frame grows by one saved word per activation. The arguments do **not** need
to be saved: `a0` and `a1` are caller-saved, and the caller is finished with
them once the call is made. The result comes back in `a0`, which is exactly
where the caller wants it.

Recursion depth for 1071 and 462 is around sixty activations (there are about
fifty subtractions plus the swaps), so the stack holds roughly 60 x 8 = 480
bytes at the deepest point. The number of instructions executed is larger than
the loop version for the same reason: every subtraction now costs a call, a
save, a restore and a return.

The base case shares the epilogue: `beq a1, zero, base` jumps straight to the
`jalr` at the end, so an activation whose `b` is already zero never allocates a
frame.
