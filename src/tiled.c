#define MC 120
#define KC 256
#define NC 128

static int min_int(int a, int b) {return a<b ? a:b;}

static void tiled_block_scalar(int mc, int nc, int kc, const float *A, int lda, const float *B, int ldb, float *C, int ldc);

void frogemm_tiled(int M, int N, int K, const float *A, const float *B, float *C) {
	for (int i = 0; i < M * N; i++) C[i] = 0.0f;

	for (int ic = 0; ic < M; ic += MC) {
		int mc = min_int(MC, M - ic);
		for (int jc = 0; jc < N; jc += NC) {
			int nc = min_int(NC, N - jc);
			for (int pc = 0; pc < K; pc += KC) {
				int kc = min_int(KC, K - pc);
				tiled_block_scalar(
					mc, nc, kc,
					A + ic*K + pc, K,
					B + pc*N + jc, N,
					C + ic*N + jc, N
				);
			}
		}
	}
}

static void tiled_block_scalar(int mc, int nc, int kc, const float *A, int lda, const float *B, int ldb, float *C, int ldc) {
	for (int i = 0; i < mc; i++) {
		for (int k = 0; k < kc; k++) {
			float a = A[i*lda + k];
			for (int j = 0; j < nc; j++) {
				C[i*ldc + j] += a * B[k*ldb + j];
			}
		}
	}
}