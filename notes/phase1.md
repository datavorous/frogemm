# Phase 1

1. Wrote the naive matmul.
2. Need to profile with different compiler flags.  
    a. Need to consider the median  
3. Calculate efficiency; efficiency = `(2*M*N*K FLOPs)/(time_seconds * peak_GFLOPS * 1e9)`

Benchmark setup:
- Shape: `M=N=K=512`
- Kernel: `naive`
- Runs: `10`, excluding first `2` (cold start)
- Peak reference: `540 GFLOPS` from `notes/device.md`

Compiler flag comparison:

1. `-O0 -Iinclude`
median time: `552924.5 us`  
efficiency: `0.09%`

2. `-O2 -Iinclude`
median time: `211749.0 us`  
efficiency: `0.23%`

3. `-O3 -Iinclude`
median time: `218277.5 us`  
efficiency: `0.23%`

4. `-Ofast -march=native -Iinclude`
median time: `234614.0 us`  
efficiency: `0.21%`

Observation:
- `-O2` was best for this current naive implementation on this machine.
