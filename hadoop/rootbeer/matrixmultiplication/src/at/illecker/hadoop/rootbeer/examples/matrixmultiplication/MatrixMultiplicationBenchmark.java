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
package at.illecker.hadoop.rootbeer.examples.matrixmultiplication;

import java.io.IOException;
import java.util.Random;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IOUtils;
import org.apache.hadoop.util.ToolRunner;
import org.apache.mahout.common.AbstractJob;

import com.google.caliper.Benchmark;
import com.google.caliper.Param;
import com.google.caliper.api.Macrobenchmark;
import com.google.caliper.runner.CaliperMain;

public class MatrixMultiplicationBenchmark extends Benchmark {

  @Param({ "256", "384", "512", "768", "1024" })
  private int n;

  @Param
  CalcType type;

  public enum CalcType {
    // JAVA,
    CPU, GPU
  };

  // private static final Log LOG =
  // LogFactory.getLog(MatrixMultiplicationBenchmark.class);
  private static final String OUTPUT_DIR = "output/hadoop/rootbeer/examples/matrixmultiplication/bench";

  private Path OUTPUT_DIR_PATH;
  private Path MATRIX_A_PATH;
  private Path MATRIX_B_PATH;
  private Path MATRIX_C_PATH;
  private Path MATRIX_D_PATH;

  private Configuration conf;

  private DistributedRowMatrix matrixA;
  private DistributedRowMatrix matrixB;
  private boolean runLocally = false;

  @Override
  protected void setUp() throws Exception {
    conf = new Configuration();
    String HADOOP_HOME = System.getenv("HADOOP_HOME");
    String HADOOP_INSTALL = System.getenv("HADOOP_INSTALL");

    if ((HADOOP_HOME != null) || (HADOOP_INSTALL != null) && (!runLocally)) {
      String HADOOP = ((HADOOP_HOME != null) ? HADOOP_HOME : HADOOP_INSTALL);

      conf.addResource(new Path(HADOOP, "src/core/core-default.xml"));
      conf.addResource(new Path(HADOOP, "src/hdfs/hdfs-default.xml"));
      conf.addResource(new Path(HADOOP, "src/mapred/mapred-default.xml"));
      conf.addResource(new Path(HADOOP, "conf/core-site.xml"));
      conf.addResource(new Path(HADOOP, "conf/hdfs-site.xml"));
      conf.addResource(new Path(HADOOP, "conf/mapred-site.xml"));

      System.out.println("Loaded Hadoop configuration from " + HADOOP);

      try {
        // Connect to HDFS Filesystem
        FileSystem.get(conf);
      } catch (Exception e) {
        // HDFS not reachable run Benchmark locally
        conf = new Configuration();
        runLocally = true;
      }
    }

    // Setup outputs
    OUTPUT_DIR_PATH = new Path(OUTPUT_DIR + "/bench_"
        + System.currentTimeMillis());
    System.out.println("OUTPUT_DIR_PATH: " + OUTPUT_DIR_PATH);

    MATRIX_A_PATH = new Path(OUTPUT_DIR_PATH + "/MatrixA.seq");
    MATRIX_B_PATH = new Path(OUTPUT_DIR_PATH + "/MatrixB.seq");
    MATRIX_C_PATH = new Path(OUTPUT_DIR_PATH + "/MatrixC.seq");
    MATRIX_D_PATH = new Path(OUTPUT_DIR_PATH + "/MatrixD.seq");

    System.out.println("Benchmark " + n + " x " + n + " matrix");
    // Create random DistributedRowMatrix
    DistributedRowMatrix.createRandomDistributedRowMatrix(conf, n, n,
        new Random(42L), MATRIX_A_PATH, true);
    DistributedRowMatrix.createRandomDistributedRowMatrix(conf, n, n,
        new Random(), MATRIX_B_PATH, false);

    // Load DistributedRowMatrix a and b
    matrixA = new DistributedRowMatrix(MATRIX_A_PATH, OUTPUT_DIR_PATH, n, n);
    matrixB = new DistributedRowMatrix(MATRIX_B_PATH, OUTPUT_DIR_PATH, n, n);

    matrixA.setConf(conf);
    matrixB.setConf(conf);
  }

  @Override
  protected void tearDown() throws Exception {

    verify();

    // Cleanup
    FileSystem fs = FileSystem.get(conf);
    fs.delete(MATRIX_A_PATH, true);
    fs.delete(MATRIX_B_PATH, true);
    fs.delete(MATRIX_C_PATH, true);
    fs.delete(MATRIX_D_PATH, true);

    printOutput(conf);
  }

  private void verify() throws Exception {

    DistributedRowMatrix matrixC = new DistributedRowMatrix(MATRIX_C_PATH,
        OUTPUT_DIR_PATH, n, n);
    matrixC.setConf(conf);

    // Overwrite matrix A, NOT transposed for verification check
    DistributedRowMatrix.createRandomDistributedRowMatrix(conf, n, n,
        new Random(42L), MATRIX_A_PATH, false);
    matrixA = new DistributedRowMatrix(MATRIX_A_PATH, OUTPUT_DIR_PATH, n, n);
    matrixA.setConf(conf);

    DistributedRowMatrix matrixD = matrixA.multiplyJava(matrixB, MATRIX_D_PATH);

    if (matrixC.verify(matrixD)) {
      System.out.println("Verify PASSED!");
    } else {
      System.out.println("Verify FAILED!");
    }
  }

  static void printOutput(Configuration conf) throws IOException {
    FileSystem fs = FileSystem.get(conf);
    FileStatus[] files = fs.listStatus(new Path(OUTPUT_DIR));
    for (int i = 0; i < files.length; i++) {
      if (files[i].getLen() > 0) {
        System.out.println("File " + files[i].getPath());
        FSDataInputStream in = fs.open(files[i].getPath());
        IOUtils.copyBytes(in, System.out, conf, false);
        in.close();
      }
    }
    // fs.delete(FileOutputFormat.getOutputPath(job), true);
  }

  // Microbenchmark
  // Uncomment Macro to use Micro
  public void timeCalculate(int reps) {
    int sum = 0;
    for (int rep = 0; rep < reps; rep++) {
      sum = doBenchmark(sum);
    }
    System.out.println(sum);
  }

  @Macrobenchmark
  public void timeCalculate() {
    doBenchmark(0);
  }

  public int doBenchmark(int sum) {
    switch (type) {
    /*
     * case JAVA: sum = matrixMultiplyJava(sum); break;
     */
      case CPU:
        sum = matrixMultiplyHadoopCPU(sum);
        break;
      case GPU:
        sum = matrixMultiplyHadoopGPU(sum);
        break;
      default:
        break;
    }
    return sum;
  }

  private class MatrixMultiplication extends AbstractJob {
    private boolean javaOnly;
    private boolean useGPU;

    public MatrixMultiplication(boolean javaOnly, boolean useGPU) {
      this.javaOnly = javaOnly;
      this.useGPU = useGPU;
    }

    @Override
    public int run(String[] arg0) throws Exception {

      DistributedRowMatrix resultMatrix = null;
      if (javaOnly) {
        resultMatrix = matrixA.multiplyJava(matrixB, MATRIX_C_PATH);
      } else {
        resultMatrix = matrixA.multiplyMapReduce(matrixB, MATRIX_C_PATH,
            useGPU, true);
      }

      return resultMatrix.numRows();
    }
  }

  private int matrixMultiplyJava(int sum) {
    try {
      sum += ToolRunner.run(new MatrixMultiplication(true, false), null);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return sum;
  }

  private int matrixMultiplyHadoopCPU(int sum) {
    try {
      sum += ToolRunner.run(new MatrixMultiplication(false, false), null);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return sum;
  }

  private int matrixMultiplyHadoopGPU(int sum) {
    try {
      sum += ToolRunner.run(new MatrixMultiplication(false, true), null);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return sum;
  }

  public static void main(String[] args) {
    CaliperMain.main(MatrixMultiplicationBenchmark.class, args);
  }

}
