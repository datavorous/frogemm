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

## Build As A Standalone Library

Build static library and header:

```bash
make lib
```

This creates `libfrogemm.a` and uses the public header `include/frogemm.h`.

Install system-wide (optional):

```bash
sudo make install
```

Use custom prefix:

```bash
make install PREFIX=/path/to/prefix
```

Link from another project:

```bash
gcc main.c -I/path/to/frogemm/include -L/path/to/frogemm -lfrogemm -o app
```

## OpenMP / Parallel Support

`frogemm_tiled` uses OpenMP for parallel execution.

Build with OpenMP enabled (default in this repo):

```bash
make bench-ofast
make lib
```

If you link `libfrogemm.a` from another project, also link OpenMP runtime:

```bash
gcc main.c -I/path/to/frogemm/include -L/path/to/frogemm -lfrogemm -fopenmp -o app
```

Control thread count at runtime:

```bash
OMP_NUM_THREADS=8 OMP_DYNAMIC=false OMP_PROC_BIND=true OMP_PLACES=cores ./bench/bench 1024 1024 1024
```

Notes:
- `frogemm_naive` is single-threaded.
- OpenMP thread count is chosen at runtime (not fixed at library build time).

## Example

```c
#include <stdio.h>
#include <stdlib.h>
#include "frogemm.h"

int main() {
    const int M = 2, N = 2, K = 2;
    float A[4] = {1, 2, 3, 4}; // 2x2
    float B[4] = {5, 6, 7, 8}; // 2x2
    float C[4];

    frogemm_tiled(M, N, K, A, B, C);
    // or: frogemm_naive(M, N, K, A, B, C);

    printf("[%.1f %.1f]\n[%.1f %.1f]\n", C[0], C[1], C[2], C[3]);
    return 0;
}
```

## Kernels Implemented

1. `frogemm_naive`: implemented
2. `frogemm_tiled`: implemented with multi threading