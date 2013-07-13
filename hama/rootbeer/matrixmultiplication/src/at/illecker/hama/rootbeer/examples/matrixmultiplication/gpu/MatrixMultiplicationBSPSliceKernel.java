/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package at.illecker.hama.rootbeer.examples.matrixmultiplication.gpu;

import edu.syr.pcpratts.rootbeer.runtime.Kernel;
import edu.syr.pcpratts.rootbeer.runtime.RootbeerGpu;

public class MatrixMultiplicationBSPSliceKernel implements Kernel {

  // input
  private double[][] rowsA;
  private double[][] matrixB;
  public int blockSize;
  public int gridSize;
  // output
  public int[] rowAId;
  public double[] results = null;

  // debug
  /*
   * public double[][] currBColumns; public int[] sumResultsSetSharedMemIndex;
   * public double[] sumResultsSetSharedMemValues; public int[]
   * sumResultsGetSharedMemIndex; public double[] sumResultsGetSharedMemValues;
   */
  public ResultList resultList;

  public MatrixMultiplicationBSPSliceKernel(int[] rowAId, double[][] rowsA,
      double[][] matrixB, int blockSize, int gridSize) {
    this.rowAId = rowAId;
    this.rowsA = rowsA;
    this.matrixB = matrixB;
    this.blockSize = blockSize;
    this.gridSize = gridSize;
    resultList = new ResultList();
  }

  public void gpuMethod() {

    // int blockSize = RootbeerGpu.getBlockDimx();
    // int gridSize = RootbeerGpu.getGridDimx();
    int block_idxx = RootbeerGpu.getBlockIdxx();
    int thread_idxx = RootbeerGpu.getThreadIdxx();
    // int globalThreadIndex = block_idxx * blockSize + thread_idxx;

    int matrixARows = rowsA.length;
    int matrixAColSize = rowsA[0].length;
    int matrixBRowSize = this.matrixB.length;
    int matrixBColSize = this.matrixB[0].length;

    // Check for wrong matrix sizes
    if (matrixAColSize != matrixBRowSize) {
      return;
    }

    // threadSliceSize defines how much multipliers of row A a thread has to
    // compute with rows of col B
    int threadSliceSize = matrixAColSize / blockSize;

    // blockSliceSize defines the column slice amount
    // columns of B per blockIters
    int blockSliceSize = matrixBColSize / gridSize;

    // Setup shared memory only within first thread of block
    if (thread_idxx == 0) {
      results = new double[matrixBColSize];
    }

    // Shared Memory Start Indexes
    int bColsStartIndex = 0;
    int threadSlizeResultsStartIndex = bColsStartIndex + 
        (blockSize * blockSliceSize * threadSliceSize * 8);
    // int resultsStartIndex = columnSlizeResultsStartIndex + blockSize * 8;

    // Debug
    int[] bColsSharedMemIndex = new int[blockSliceSize * threadSliceSize];
    double[] bColsSharedMemValues = new double[blockSliceSize * threadSliceSize];

    
    // Each thread sets its own shared memory within their blocks
    // Setup columns of matrix B to shared memory
    for (int i = 0; i < blockSliceSize; i++) {
      for (int j = 0; j < threadSliceSize; j++) {

        int sharedMemIndex = bColsStartIndex
            + (thread_idxx * blockSliceSize * threadSliceSize * 8)
            + (i * threadSliceSize * 8) + (j * 8);

        bColsSharedMemIndex[(i * threadSliceSize) + j] = sharedMemIndex;

        RootbeerGpu.setSharedDouble(sharedMemIndex, this.matrixB[thread_idxx
            * threadSliceSize + j][(block_idxx * blockSliceSize) + i]);

        bColsSharedMemValues[(i * threadSliceSize) + j] = RootbeerGpu
            .getSharedDouble(sharedMemIndex);
      }
    }

    // Sync threads, until shared memory is established
    RootbeerGpu.syncthreads();

    // Debug
    double[][] multipliers = new double[matrixARows][threadSliceSize];
    double[][][] bColsVals = new double[blockSliceSize][matrixARows][threadSliceSize];
    // Debug
    int[][] threadResultsSharedMemIndex = new int[blockSliceSize][matrixARows];
    double[][] threadResultsSharedMemValues = new double[blockSliceSize][matrixARows];

    for (int k = 0; k <blockSliceSize; k++) {
    
     for (int i = 0; i < matrixARows; i++) {

      double sum = 0;
      for (int j = 0; j < threadSliceSize; j++) {

        double multiplier = rowsA[i][(thread_idxx * threadSliceSize) + j];
        multipliers[i][j] = multiplier;

        bColsVals[k][i][j] = RootbeerGpu.getSharedDouble((k * blockSliceSize * 8)
            + (thread_idxx * blockSliceSize * threadSliceSize * 8)
            + (j * 8));
        
        sum += multiplier
            * RootbeerGpu.getSharedDouble((k * blockSliceSize * 8)
                + (thread_idxx * blockSliceSize * threadSliceSize * 8)
                + (j * 8));
      }

      int sharedMemIndex = threadSlizeResultsStartIndex
          + (k * threadSliceSize * blockSliceSize * 8)
          + (thread_idxx * threadSliceSize * matrixARows * 8) 
          + (i * 8);

      threadResultsSharedMemIndex[k][i] = sharedMemIndex;

      RootbeerGpu.setSharedDouble(sharedMemIndex, sum);

      threadResultsSharedMemValues[k][i] = RootbeerGpu
          .getSharedDouble(sharedMemIndex);
     }
    }

    // Sync threads, until every thread has finished
    RootbeerGpu.syncthreads();

    // Resulting output
    Result result = new Result();
    result.thread_idxx = thread_idxx;
    result.block_idxx = block_idxx;
    result.threadSliceSize = threadSliceSize;
    result.blockSliceSize = blockSliceSize;
    result.bColsSharedMemIndex = bColsSharedMemIndex;
    result.bColsSharedMemValues = bColsSharedMemValues;

    result.multipliers = multipliers;
    result.bColsVals = bColsVals;

    result.threadResultsSharedMemIndex = threadResultsSharedMemIndex;
    result.threadResultsSharedMemValues = threadResultsSharedMemValues;
    
    // set fields to null otherwise rootbeer will eliminate it
    result.blockResultsSharedMemIndex =  null;
    result.blockResultsSharedMemValues = null;
    result.resultCols = null;
    

    // Thread 0 of each block accumulates results
    if (thread_idxx == 0) {

      // Debug
      int[][] blockResultsSharedMemIndex = new int[blockSize][matrixARows];
      double[][] blockResultsSharedMemValues = new double[blockSize][matrixARows];
      
      double[] resultCols = new double[matrixARows];

      
      // Collect results for each thread
      for (int i = 0; i < blockSize; i++) {

        double sum = 0;
        for (int j = 0; j < matrixARows; j++) {

          int sharedMemIndex = threadSlizeResultsStartIndex
              + (i * 8) + (j * matrixARows * 8);

          blockResultsSharedMemIndex[i][j] = sharedMemIndex;
          blockResultsSharedMemValues[i][j] = RootbeerGpu
              .getSharedDouble(sharedMemIndex);

          sum += blockResultsSharedMemValues[i][j];
        }
        resultCols[i] = sum;
      }
      
      result.blockResultsSharedMemIndex = blockResultsSharedMemIndex;
      result.blockResultsSharedMemValues = blockResultsSharedMemValues;
      result.resultCols = resultCols;

    }
    
    resultList.add(result);

    
    
    
    // Accumulation of thread results using Parallel Scan
    /*
    int[] reductionSharedMemIndex = new int[blockSize];
    for (int i=0; i<reductionSharedMemIndex.length; i++)
      reductionSharedMemIndex[i] = 0;
    
    // Reduction
    int stride;
    for (stride = 1; stride <= blockSize; stride <<= 1) {
       int index = (thread_idxx + 1) * stride * 2 - 1;
       
       reductionSharedMemIndex
       
       if (index < 2 * blockSize) {
          scan_array[index] += scan_array[index - stride];
       }
       RootbeerGpu.syncthreads();
    }
 
    // Post reduction
    for (stride = blockSize >> 1; stride; stride >>= 1) {
       int index = (thread_idxx + 1) * stride * 2 - 1;
       if (index + stride < 2 * blockSize)
          scan_array[index + stride] += scan_array[index];
       RootbeerGpu.syncthreads();
    }
 
    if (start + t < len)
       output[start + t] = scan_array[t];
    if (start + BLOCK_SIZE + t < len)
       output[start + BLOCK_SIZE + t] = scan_array[BLOCK_SIZE + t];
 
    if (aux && t == 0)
       aux[blockIdx.x] = scan_array[2 * BLOCK_SIZE - 1];
    
    */
  }

  public static void main(String[] args) {
    // Dummy invocations to keep methods via
    // rootbeer transformation
    new MatrixMultiplicationBSPSliceKernel(null, null, null, 0, 0);
    new ResultList().getList();
    new Result().toString();
  }
}
