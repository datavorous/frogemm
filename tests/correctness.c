#include <stdio.h>
#include <math.h>
#include <assert.h>

void verify(float *C_ref, float *C, int M, int N, int tol) {
    for(int i = 0; i < M*N; i++) {
        assert(fabsf(C_ref[i] - C[i]) < tol);
    }
    printf("[+] PASSED\n");
}