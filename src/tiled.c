#define MC 120
#define KC 256
#define NC 128

static int min_int(int a, int b) {return a<b ? a:b;}

static void tiled_block_scalar(int mc, int nc, int kc, const float *A, int lda, const float *B, int ldb, float *C, int ldc);

void frogemm_tiled(int M, int N, int K, const float *A, const float *B, float *C) {
    const int mt = (M + MC - 1) / MC;
    const int nt = (N + NC - 1) / NC;
	for (int i = 0; i < M * N; i++) C[i] = 0.0f;

    #pragma omp parallel for collapse(2) schedule(static)
	for (int ti = 0; ti < mt; ti++) {
		for(int tj = 0; tj < nt; tj++) {
            const int ic = ti * MC;
            const int jc = tj * NC;
            const int mc = min_int(MC, M - ic);
            const int nc = min_int(NC, N - jc);

            for(int pc = 0; pc < K; pc += KC) {
                const int kc = min_int(KC, K - pc);
                tiled_block_scalar(
                    mc, nc, kc,
                    A + ic * K + pc, 
                    K, B + pc * N + jc, 
                    N, C + ic * N + jc, N);
            }
		}
	}
}

static void tiled_block_scalar(int mc, int nc, int kc, const float *A, int lda, const float *B, int ldb, float *C, int ldc) {
	for (int i = 0; i < mc; i++) {
        float *c_row = C + i * ldc;
        const float *a_row = A + i * lda;


		for (int k = 0; k < kc; k++) {
            const float a = a_row[k];
            const float *b_row = B + k * ldb;


			#pragma omp simd
			for (int j = 0; j < nc; j++) {
				c_row[j] += a * b_row[j];
			}
		}
	}
}