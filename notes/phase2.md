# Phase 2

Tiling

Benchmark setup:
- Shape: `M=N=K=512`
- Runs: `10`, excluding first `2`
- Peak reference: `540 GFLOPS`
- Turbo Boost: disabled

Naive vs tiled:

1. `-O0 -Iinclude`
- `naive`: `624538.0 us`, `0.08%`
- `tiled`: `768865.5 us`, `0.06%`

2. `-O2 -Iinclude`
- `naive`: `161544.0 us`, `0.31%`
- `tiled`: `140180.0 us`, `0.35%`

3. `-O3 -Iinclude`
- `naive`: `65231.5 us`, `0.76%`
- `tiled`: `62257.5 us`, `0.80%`

4. `-Ofast -march=native -Iinclude`
- `naive`: `37964.0 us`, `1.31%`
- `tiled`: `36450.5 us`, `1.36%`

Observation:
- `tiled` is faster than `naive` at `-O2`, `-O3`, and `-Ofast` in this run, but slower at `-O0`.

## OpenMP Benchmark (2026-02-26) - 512, 1024, 2048

Benchmark setup:
- Build: `make bench-ofast`
- Flags: `-Ofast -march=native -Iinclude -fopenmp`
- Runtime env: `OMP_NUM_THREADS=8 OMP_PROC_BIND=true OMP_PLACES=cores OMP_DYNAMIC=false`
- Runs: `10`, excluding first `2`
- Timing: wall-clock (`clock_gettime(CLOCK_MONOTONIC)`)
- Turbo Boost: disabled

Results:

1. `M=N=K=512`
- `naive`: `37379.6150 us`, `1.33%`
- `tiled (OpenMP)`: `14092.7810 us`, `3.53%`
- Speedup (`naive/tiled`): `2.65x`

2. `M=N=K=1024`
- `naive`: `307963.1675 us`, `1.29%`
- `tiled (OpenMP)`: `93671.9440 us`, `4.25%`
- Speedup (`naive/tiled`): `3.29x`

3. `M=N=K=2048`
- `naive`: `3439462.6410 us`, `0.92%`
- `tiled (OpenMP)`: `755889.1760 us`, `4.21%`
- Speedup (`naive/tiled`): `4.55x`
