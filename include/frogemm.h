#ifndef FROGEMM_H
#define FROGEMM_H

void frogemm_naive(int M, int N, int K, float *A, float *B, float *C);
void frogemm_tiled(int M, int N, int K, float *A, float *B, float *C);

#endif
