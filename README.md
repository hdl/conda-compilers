# Conda build recipes (compilers)

<p align="center">
  <img width=550px src="banner.png"/>
</p>

Find documentation in [hdl/conda-eda](https://github.com/hdl/conda-eda).

| Tool     | Version | Target     | C Library                                            | C Library Version  |
| -------- | ------- | ---------- | ---------------------------------------------------- | ------------------ |
| binutils | 2.32    | Bare metal |                                                      |                    |
| gcc      | 9.1.0   | Bare metal | no C library                                         |                    |
| gcc      | 9.1.0   | Bare metal | [picolibc](https://github.com/keith-packard/picolibc)| WIP                |
| gcc      | 9.1.0   | Bare metal | [newlib](https://sourceware.org/newlib/)             | 3.1.0              |
| gcc      | 9.1.0   | Linux      | [musl](https://musl-libc.org)                        | git ac304227       |
| gdb      | 8.2     | N/A        |                                                      |                    |

| Architecture Name | Abbrev    | Soft Core |
| ----------------- | --------- | --------- |
| LatticeMico32     | `lm32`    | [lm32]() |
| RISC-V 32bit      | `rv32`    | [VexRISCV](), [picorv32](), [minvera](), [tiaga?]() |
| RISC-V 64bit      | `rv64`    | [Rocket](), [BlackParrot?]() |
| OpenRISC1000      | `or1k`    | [mor1k]() |
| PowerPC 64bit     | `ppc64le` | [Microwatt]() |

* Cypress FX2 support
  * sdcc (Current version: 3.5.0)
