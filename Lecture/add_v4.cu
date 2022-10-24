/*
 * _ADD_V4_CU_
 *
 * 2022 Mert SIDE
 *
 * This file is a part of the CS5375 lectures at Texas Tech University.
 *
 * With unified memory
 *
 */

#include <iostream>
#include <math.h>

// CUDA kernel to initialize elements of two arrays
__global__ void init(int n, float *x, float *y) 
{
  int index = threadIdx.x + blockIdx.x * blockDim.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = index; i < n; i += stride) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }
}

// CUDA kernel to add elements of two arrays
__global__
void add(int n, float *x, float *y) 
{
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = index; i < n; i += stride)
    y[i] = x[i] + y[i];
}

int main(void) 
{
  int N = 1<<25; // 33M elements
  //int N = 1<<20; // 1M elements
  float *x, *y;
 
  // Allocate Unified Memory -- accessible from CPU or GPU
  cudaMallocManaged(&x, N*sizeof(float));
  cudaMallocManaged(&y, N*sizeof(float));
 
  int blockSize = 256;
  int numBlocks = (N + blockSize - 1) / blockSize;  
  
  // initialize x and y arrays on the host
  init<<<numBlocks, blockSize>>>(N, x, y); 
  
  // Launch kernel on 33M elements on the GPU
  add<<<numBlocks, blockSize>>>(N, x, y);
 
  // Wait for GPU to finish before accessing on host
  cudaDeviceSynchronize();
 
  // Check for errors (all values should be 3.0f)
  float maxError = 0.0f;
  for (int i = 0; i < N; i++)
    maxError = fmax(maxError, fabs(y[i]-3.0f));
  std::cout << "Max error: " << maxError << std::endl;
 
  // Free memory
  cudaFree(x); 
  cudaFree(y);
  
  return 0;
}
