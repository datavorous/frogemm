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
