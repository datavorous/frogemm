#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include "frogemm.h"

static void gemm_ref(int M, int N, int K, const float *A, const float *B, float *C) {
    for (int i = 0; i < M * N; i++) {
        C[i] = 0.0f;
    }

    for (int i = 0; i < M; i++) {
        for (int k = 0; k < K; k++) {
            const float a = A[i * K + k];
            for (int j = 0; j < N; j++) {
                C[i * N + j] += a * B[k * N + j];
            }
        }
    }
}

static int verify(const float *C_ref, const float *C, int M, int N, float tol) {
    for (int i = 0; i < M * N; i++) {
        if (fabsf(C_ref[i] - C[i]) > tol) {
            return i;
        }
    }
    return -1;
}

static void fill_data(float *A, float *B, int M, int N, int K) {
    for (int i = 0; i < M * K; i++) {
        A[i] = (float)((i % 17) - 8) / 8.0f;
    }
    for (int i = 0; i < K * N; i++) {
        B[i] = (float)((i % 19) - 9) / 9.0f;
    }
}

static int run_case(int M, int N, int K, float tol) {
    float *A = (float *)malloc((size_t)M * (size_t)K * sizeof(float));
    float *B = (float *)malloc((size_t)K * (size_t)N * sizeof(float));
    float *C_naive = (float *)malloc((size_t)M * (size_t)N * sizeof(float));
    float *C_tiled = (float *)malloc((size_t)M * (size_t)N * sizeof(float));
    float *C_ref = (float *)malloc((size_t)M * (size_t)N * sizeof(float));
    if (!A || !B || !C_naive || !C_tiled || !C_ref) {
        fprintf(stderr, "allocation failed for shape M=%d N=%d K=%d\n", M, N, K);
        free(A);
        free(B);
        free(C_naive);
        free(C_tiled);
        free(C_ref);
        return 1;
    }

    fill_data(A, B, M, N, K);
    gemm_ref(M, N, K, A, B, C_ref);
    frogemm_naive(M, N, K, A, B, C_naive);
    frogemm_tiled(M, N, K, A, B, C_tiled);

    int mismatch = verify(C_ref, C_naive, M, N, tol);
    if (mismatch >= 0) {
        int row = mismatch / N;
        int col = mismatch % N;
        fprintf(stderr,
                "FAIL kernel=naive M=%d N=%d K=%d at C[%d,%d]: got=%f expected=%f\n",
                M, N, K, row, col, C_naive[mismatch], C_ref[mismatch]);
        free(A);
        free(B);
        free(C_naive);
        free(C_tiled);
        free(C_ref);
        return 1;
    }

    mismatch = verify(C_ref, C_tiled, M, N, tol);
    if (mismatch >= 0) {
        int row = mismatch / N;
        int col = mismatch % N;
        fprintf(stderr,
                "FAIL kernel=tiled M=%d N=%d K=%d at C[%d,%d]: got=%f expected=%f\n",
                M, N, K, row, col, C_tiled[mismatch], C_ref[mismatch]);
        free(A);
        free(B);
        free(C_naive);
        free(C_tiled);
        free(C_ref);
        return 1;
    }

    printf("PASS M=%d N=%d K=%d (naive,tiled)\n", M, N, K);
    free(A);
    free(B);
    free(C_naive);
    free(C_tiled);
    free(C_ref);
    return 0;
}

int main(void) {
    const float tol = 1e-4f;
    const int cases[][3] = {
        {1, 1, 1},
        {2, 3, 4},
        {7, 5, 9},
        {16, 16, 16},
        {31, 17, 9},
        {64, 64, 64},
    };

    int failed = 0;
    const int num_cases = (int)(sizeof(cases) / sizeof(cases[0]));
    for (int i = 0; i < num_cases; i++) {
        failed += run_case(cases[i][0], cases[i][1], cases[i][2], tol);
    }

    if (failed == 0) {
        printf("All correctness tests passed (%d/%d).\n", num_cases, num_cases);
        return 0;
    }

    fprintf(stderr, "Correctness tests failed (%d/%d failed).\n", failed, num_cases);
    return 1;
}
