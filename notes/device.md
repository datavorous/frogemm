# Device Specifications

CPU: Intel i7-8650U(4C/8T, AVX2+FMA)  
SIMD width: 256-bit  
Peak F32 compute: ~540 GFLOPS turbo(~240 GFLOPS base)  
Cache Hierarchy: 32 KiB L1d/256 KiB L2 per core, 8MiB shared L3  
Memory: dual channel DDR4-2400, ~38.4 GB/s theoretical  

> Found out using `lscpu`, `sudo dmidecode --type memory` commands.