# Design

Final C library should have:

```c
void frogemm_naive(int M, int N, int K, float A*, float B*, float C*);
void frogemm_tiled(int M, int N, int K, float A*, float B*, float C*, int tile_size);
void frogemm_avx2(int M, int N, int K, float A*, float B*, float C*);

// micorkernels!
void frogemm_micro(int M, int N, int K, float A*, float B*, float C*);
// int8 quantized
void frogemm_int8(int M, int N, int K, int8_t *A, int8_t *B, int8_t *C, float scale_A, float scale_B);
```