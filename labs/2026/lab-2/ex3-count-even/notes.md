# Exercise 3 - count the even elements of an array

`solution.s` walks the ten-element array in `.data`, adds one to a counter for
every element whose low bit is clear, and prints `Even count: 5`.

## Registers

| Register | Holds |
|---|---|
| `s0` | base address of `array` |
| `s1` | number of elements, `n` |
| `s2` | how many elements are even |
| `t0` | loop index `i` |
| `t1` | address of `array[i]` |
| `t2` | the element itself, then its low bit |

## Notes

The array is one word per element, so the byte offset is `i * 4`, formed with
`slli t1, t0, 2` and added to the base. The even test is `andi t2, t2, 1`:
an even number has a zero in bit 0, an odd number has a one. `bne` then skips
the counter update for odd elements.

The part that was easy to get wrong was the order of the test and the counter
update: `bne t2, zero, next` has to jump *past* the `addi`, otherwise every
element is counted. The loop-exit test is `bge t0, s1, done`, the inversion of
the model's `i < n`, as in the worked example.

The array is `{8, 13, 22, 35, 40, 57, 64, 79, 96, 11}`, so the five evens are
8, 22, 40, 64 and 96.
