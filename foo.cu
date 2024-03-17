#include <stdio.h>

#define N (100*1000*1000)

__global__ void vector_add(float *out, float *a, float *b, int n) {
  int index = threadIdx.x;
  int stride = blockDim.x;

  for(int i = index; i < n; i += stride) {
	 out[i] = a[i] + b[i];
  }
}

int main(){
	 float *a, *b, *out; // host
    float *d_a, *d_b, *d_out; // device

	 cudaMallocHost((void**)&a, sizeof(float) * N);
    cudaMallocHost((void**)&b, sizeof(float) * N);
    cudaMallocHost((void**)&out, sizeof(float) * N);

    // Initialize array
    for(int i = 0; i < N; i++){
        a[i] = 1.0f; b[i] = 2.0f;
    }

    // Allocate device memory for a
    cudaMalloc((void**)&d_a, sizeof(float) * N);
    cudaMalloc((void**)&d_b, sizeof(float) * N);
    cudaMalloc((void**)&d_out, sizeof(float) * N);

		cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
		cudaMemcpy(d_b, b, sizeof(float) * N, cudaMemcpyHostToDevice);
	 for (int i = 0; i < 2; i++) {
		vector_add<<<1,256>>>(d_out, d_a, d_b, N);
	 }
		cudaMemcpy(out, d_out, sizeof(float) * N, cudaMemcpyDeviceToHost);


	 printf("vector[0] is %f\n", out[100]);

    // Cleanup after kernel execution
    cudaFree(d_a);
	 cudaFree(d_b);
	 cudaFree(d_out);
    cudaFreeHost(a);
    cudaFreeHost(b);
    cudaFreeHost(out);
}



/* __global__ void cuda_hello(){ */
/* } */

/* int main() { */
/*     cuda_hello<<<1,1>>>(); */

/*     return 0; */
/* } */
