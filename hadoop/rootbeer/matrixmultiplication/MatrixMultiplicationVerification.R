#!/usr/bin/Rscript

# Matrix Multiplication Verification

# ant run-cpu -DnumRows='--numRows 4' -DnumCols='--numCols 4'
# n=4, MatrixA(new Random(42L)), MatrixA(new Random(1337L)), matrix[i][j] = rand.nextInt(9) + 1;
A <- matrix(c(9.0,4.0,1.0,9.0,1.0,8.0,6.0,3.0,8.0,3.0,3.0,9.0,7.0,1.0,9.0,6.0),
            nrow = 4, ncol = 4, byrow = TRUE)

B <- matrix(c(2.0,1.0,6.0,5.0,7.0,8.0,9.0,5.0,2.0,1.0,5.0,8.0,7.0,4.0,4.0,9.0), 
            nrow = 4, ncol = 4, byrow = TRUE)

A.Transposed <- t(A)
print("n=4 Transposed:")
A.Transposed

C <- A %*% B
print("n=4 Result:")
C

# ant run-cpu -DnumRows='--numRows 4' -DnumCols='--numCols 4'
# n=4, MatrixA(new Random(42L)), MatrixA(new Random(1337L)), matrix[i][j] = rand.nextInt(9) + 1;
A <- matrix(c(9.0,4.0,1.0,9.0,1.0,8.0,6.0,3.0,8.0,3.0,3.0,9.0,7.0,1.0,9.0,6.0,7.0,7.0,2.0,9.0),
            nrow = 5, ncol = 4, byrow = TRUE)

B <- matrix(c(2.0,1.0,6.0,5.0,7.0,8.0,9.0,5.0,2.0,1.0,5.0,8.0), 
            nrow = 4, ncol = 3, byrow = TRUE)

A.Transposed <- t(A)
print("5x4 Transposed:")
A.Transposed

C <- A %*% B
print("5x3 Result:")
C

# ant run-cpu -DnumRows='--numRows 10' -DnumCols='--numCols 10'
# n=10, MatrixA(new Random(42L)), MatrixA(new Random(1337L)), matrix[i][j] = rand.nextInt(9) + 1;
A <- matrix(c(9.0,4.0,1.0,9.0,1.0,8.0,6.0,3.0,8.0,3.0,3.0,9.0,7.0,1.0,9.0,6.0,7.0,7.0,
              2.0,9.0,6.0,5.0,9.0,7.0,6.0,1.0,8.0,5.0,2.0,4.0,5.0,4.0,3.0,6.0,3.0,6.0,
              4.0,8.0,8.0,4.0,6.0,5.0,9.0,8.0,6.0,7.0,5.0,3.0,2.0,8.0,5.0,6.0,9.0,5.0,
              9.0,8.0,2.0,5.0,4.0,1.0,2.0,6.0,3.0,5.0,9.0,6.0,6.0,5.0,4.0,1.0,2.0,6.0,
              5.0,8.0,8.0,6.0,6.0,8.0,3.0,7.0,4.0,2.0,6.0,3.0,2.0,7.0,4.0,4.0,6.0,8.0,
              1.0,4.0,4.0,1.0,6.0,7.0,4.0,7.0,9.0,5.0),
            nrow = 10, ncol = 10, byrow = TRUE)

B <- matrix(c(2.0,1.0,6.0,5.0,7.0,8.0,9.0,5.0,2.0,1.0,5.0,8.0,7.0,4.0,4.0,9.0,5.0,5.0,
              6.0,1.0,2.0,1.0,1.0,7.0,8.0,5.0,7.0,3.0,6.0,5.0,6.0,5.0,9.0,8.0,5.0,6.0,
              9.0,4.0,6.0,5.0,7.0,4.0,3.0,3.0,7.0,6.0,5.0,2.0,7.0,9.0,7.0,6.0,8.0,1.0,
              7.0,1.0,2.0,2.0,9.0,2.0,5.0,8.0,4.0,7.0,1.0,5.0,8.0,5.0,9.0,2.0,6.0,7.0,
              9.0,9.0,2.0,3.0,2.0,7.0,1.0,2.0,3.0,5.0,1.0,9.0,1.0,3.0,8.0,7.0,1.0,2.0,
              3.0,2.0,8.0,2.0,8.0,5.0,5.0,8.0,9.0,5.0), 
            nrow = 10, ncol = 10, byrow = TRUE)

A.Transposed <- t(A)
print("n=10 Transposed:")
A.Transposed

C <- A %*% B
print("n=10 Result:")
C





