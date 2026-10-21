# Lab 0 — Environment Setup

**Course:** CS3520 — Computer Organisation and Architecture I  
**Student:** Tiisetso (ID: 202409095)  
**Lab Title:** Environment Setup — VS Code, Ripes & the Course Repository  

---

## Overview
This lab establishes the core toolchain for CS3520:
- Git version control and GitHub course repository
- Visual Studio Code assembly environment
- Ripes RISC-V simulator (Single Cycle / 5-Stage Pipeline)

## Lab Program
The introductory program `hello_world.s` demonstrates:
1. Allocating string data in the `.data` segment using `.asciz`
2. Setting arguments (`a0` string address, `a7 = 4` print string syscall)
3. Issuing `ecall` to invoke simulator environment calls
4. Setting `a7 = 10` (exit syscall) to terminate cleanly

## Simulation Statistics (Ripes)
When assembled and executed in Ripes (Standard Single-Cycle / 5-stage RISC-V 32-bit):
- **Cycles:** Total clock cycles taken by the program
- **CPI (Cycles Per Instruction):** Average clock cycles per instruction
- **IPC (Instructions Per Cycle):** Average instructions retired per cycle ($IPC = 1 / CPI$)
- **Clock rate:** Configured simulation frequency in Ripes
