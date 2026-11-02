# Step 5 - B-type and J-type encodings

One branch and one jump taken from the solutions, with the 32-bit word Ripes
generates, split into its fields.

## The branch: `bge t0, t1, show`

From [`ex1-larger-of-two/solution.s`](ex1-larger-of-two/solution.s), at address
`0x00000014`. The label `show` is at `0x0000001C`, so the offset is `+8`.

```text
0x0062D463
0000 0000 0110 0010 1101 0100 0110 0011
```

| Field | Bits | Value | Meaning |
|---|---|---|---|
| `imm[12]` | 31 | `0` | sign bit of the offset |
| `imm[10:5]` | 30-25 | `000000` | high offset bits |
| `rs2` | 24-20 | `00110` | `t1` = x6, the second value |
| `rs1` | 19-15 | `00101` | `t0` = x5, the first value |
| `funct3` | 14-12 | `101` | BGE |
| `imm[4:1]` | 11-8 | `0100` | low offset bits |
| `imm[11]` | 7 | `0` | middle offset bit |
| `opcode` | 6-0 | `1100011` | BRANCH |

Reassembling the immediate in its architectural order:

```text
imm[12] imm[11] imm[10:5] imm[4:1] 0
   0        0      000000     0100  0   = 0b1000 = 8
```

`0x14 + 8 = 0x1C`, which is `show`. The comparison that decides the branch is
`t0 >= t1`, i.e. `17 >= 42`, which is false, so this particular branch is not
taken and the next instruction executes.

Note that B-type has no `rd` field: a branch writes no register. Bits 11-7,
which hold `rd` in every other format, are reused for `imm[4:1]` and `imm[11]`.

## The jump: `jal ra, factorial`

From [`ex4-factorial/solution.s`](ex4-factorial/solution.s), at address
`0x00000008`. The label `factorial` is at `0x00000044`, so the offset is `+60`.

```text
0x03C000EF
0000 0011 1100 0000 0000 0000 1110 1111
```

| Field | Bits | Value | Meaning |
|---|---|---|---|
| `imm[20]` | 31 | `0` | sign bit of the offset |
| `imm[10:1]` | 30-21 | `0000011110` | offset bits 10 down to 1 |
| `imm[11]` | 20 | `0` | offset bit 11 |
| `imm[19:12]` | 19-12 | `00000000` | offset bits 19 down to 12 |
| `rd` | 11-7 | `00001` | `ra` = x1, the link register |
| `opcode` | 6-0 | `1101111` | JAL |

Reassembling the immediate:

```text
imm[20] imm[19:12] imm[11] imm[10:1] 0
   0      00000000     0     0000011110  0   = 0b111100 = 60
```

`0x08 + 60 = 0x44`, which is `factorial`. JAL writes `pc + 4 = 0x0C` into
`ra`, so the procedure can return past the call. The J-type immediate is 21
bits counting the sign bit and the implicit zero, giving a range of about
±1 MiB; the B-type immediate is 13 bits, giving about ±4 KiB.

## Why the immediate is scattered instead of one contiguous field

Every RISC-V format keeps the same five things in the same bit positions:

```text
opcode  bits 6-0
rd      bits 11-7
funct3  bits 14-12
rs1     bits 19-15
rs2     bits 24-20
```

That is what lets one decoder, one register-file read port pair and one ALU
control path serve all six formats: the wires from those bit positions go
straight to the same places whatever instruction is being decoded. If the
immediate were one contiguous field, the fields it displaces would have to move
from format to format, and the register file and decoder would need
format-dependent input multiplexors.

The solution is to keep the fixed fields fixed and give the immediate whatever
bits are left over. B-type has no `rd`, so bits 11-7 become `imm[4:1]` and
`imm[11]`; the space where R-type keeps `funct7` (bits 31-25) becomes
`imm[12]` and `imm[10:5]`; the sign bit goes to bit 31 in every format that has
an immediate, so sign extension is one wire. J-type has no `rs2`, no `funct3`
and only one immediate operand, so almost all of bits 31-12 are immediate and
`rd` stays where it always is.

The cost is a small amount of wiring to reassemble the immediate before the
branch adder; the benefit is that the register file, decoder and ALU never have
to know which format they are looking at. The low bit of both offsets is not
stored at all, because control transfers are at least 2-byte aligned, so it is
always zero - that buys one extra bit of range for free.
