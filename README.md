# frogemm

**frogemm** is a small GEMM library to do fast matrix multiplications.

> [!WARNING]
> Not a BLAS replacement, but an answer to the "itch to create" a GEMM lib from the ground up.

## Quick Usage

From repo root:

```bash
make
./bench/bench 512 512 512
./bench/bench 512 512 512 naive
```

## Kernels Implemented

1. `frogemm_naive`: `35480.5 us` (median), `1.40%` efficiency, with `512^3` and `-Ofast -march=native` flags
