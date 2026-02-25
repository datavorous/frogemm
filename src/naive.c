/*
M: rows of A (and C)
N: columns of B (and C)
K: columns of A and rows of B

algo:

for each row i in matrix A:
    for each column j in matrix B:
        sum = 0
        for each element k (0 to k-1):
            sum += A[i][k] * B[k][j]
        C[i][j] = sum
*/

void frogemm_naive(int M, int N, int K, float *A, float *B, float *C) {
    for(int i = 0; i < M; i++) {
        for(int j = 0; j < N; j++) {
            float sum = 0.0f;
            for(int k = 0; k < K; k++) {
                sum += A[i*K + k] * B[k*N + j];
            }
            C[i*N + j] = sum;
        }
    }
}