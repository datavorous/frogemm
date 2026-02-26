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
- Turbo Boost: disabled

Compiler flag comparison:

1. `-O0 -Iinclude`
median time: `1166209.0 us`  
efficiency: `0.04%`

2. `-O2 -Iinclude`
median time: `433362.0 us`  
efficiency: `0.11%`

3. `-O3 -Iinclude`
median time: `483796.5 us`  
efficiency: `0.10%`

4. `-Ofast -march=native -Iinclude`
median time: `470632.0 us`  
efficiency: `0.11%`

Observation:
- `-O2` was best for this i-j-k naive implementation on this machine.

## Changed i-j-k to i-k-j.

Compiler flag comparison:

1. `-O0 -Iinclude`
median time: `635838.5 us`  
efficiency: `0.08%`

2. `-O2 -Iinclude`
median time: `146596.0 us`  
efficiency: `0.34%`

3. `-O3 -Iinclude`
median time: `46934.0 us`  
efficiency: `1.06%`

4. `-Ofast -march=native -Iinclude`
median time: `35480.5 us`  
efficiency: `1.40%`

Observation:
- `-Ofast -march=native` is best for this updated naive implementation on this machine.
