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
package at.illecker.hama.rootbeer.examples.piestimator.gpu;

import java.io.IOException;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IOUtils;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hama.HamaConfiguration;
import org.apache.hama.bsp.BSP;
import org.apache.hama.bsp.BSPJob;
import org.apache.hama.bsp.BSPPeer;
import org.apache.hama.bsp.FileOutputFormat;
import org.apache.hama.bsp.NullInputFormat;
import org.apache.hama.bsp.TextOutputFormat;
import org.apache.hama.bsp.sync.SyncException;

import edu.syr.pcpratts.rootbeer.runtime.Rootbeer;
import edu.syr.pcpratts.rootbeer.runtime.StatsRow;
import edu.syr.pcpratts.rootbeer.runtime.util.Stopwatch;

/**
 * @author PiEstimator Monte Carlo computation of pi
 *         http://de.wikipedia.org/wiki/Monte-Carlo-Algorithmus
 * 
 *         Generate random points in the square [-1,1] X [-1,1]. The fraction of
 *         these that lie in the unit disk x^2 + y^2 <= 1 will be approximately
 *         pi/4.
 */

public class PiEstimatorGpuBSP extends
    BSP<NullWritable, NullWritable, Text, DoubleWritable, DoubleWritable> {
  private static final Log LOG = LogFactory.getLog(PiEstimatorGpuBSP.class);
  private static final Path TMP_OUTPUT = new Path(
      "output/hama/rootbeer/examples/piestimator/GPU-"
          + System.currentTimeMillis());
  private static final long totalIterations = 896000000L;
  // Long.MAX = 9223372036854775807

  // gridSize = amount of blocks and multiprocessors
  private static final int gridSize = 14;
  // blockSize = amount of threads
  private static final int blockSize = 128;
  // threads

  private String m_masterTask;
  private long m_iterations;
  private long m_calculationsPerThread;
  private int m_gridSize;
  private int m_blockSize;

  @Override
  public void setup(
      BSPPeer<NullWritable, NullWritable, Text, DoubleWritable, DoubleWritable> peer)
      throws IOException {

    // Choose one as a master
    this.m_masterTask = peer.getPeerName(peer.getNumPeers() / 2);

    this.m_iterations = Long.parseLong(peer.getConfiguration().get(
        "piestimator.iterations"));

    this.m_gridSize = Integer.parseInt(peer.getConfiguration().get(
        "piestimator.gridSize"));

    this.m_blockSize = Integer.parseInt(peer.getConfiguration().get(
        "piestimator.blockSize"));

    int threadCount = m_blockSize * m_gridSize;

    m_calculationsPerThread = divup(m_iterations, threadCount);
  }

  @Override
  public void bsp(
      BSPPeer<NullWritable, NullWritable, Text, DoubleWritable, DoubleWritable> peer)
      throws IOException, SyncException, InterruptedException {

    PiEstimatorKernel kernel = new PiEstimatorKernel(m_calculationsPerThread,
        System.currentTimeMillis());
    Rootbeer rootbeer = new Rootbeer();
    rootbeer.setThreadConfig(m_blockSize, m_gridSize, m_blockSize * m_gridSize);

    // Run GPU Kernels
    Stopwatch watch = new Stopwatch();
    watch.start();
    rootbeer.runAll(kernel);
    watch.stop();

    // Write log to dfs
    BSPJob job = new BSPJob((HamaConfiguration) peer.getConfiguration());
    FileSystem fs = FileSystem.get(peer.getConfiguration());
    FSDataOutputStream outStream = fs.create(new Path(FileOutputFormat
        .getOutputPath(job), peer.getTaskId() + ".log"));

    outStream.writeChars("BSP=PiEstimatorGpuBSP,Iterations=" + m_iterations
        + ",GPUTime=" + watch.elapsedTimeMillis() + "ms\n");
    List<StatsRow> stats = rootbeer.getStats();
    for (StatsRow row : stats) {
      outStream.writeChars("  StatsRow:\n");
      outStream.writeChars("    init time: " + row.getInitTime() + "\n");
      outStream.writeChars("    serial time: " + row.getSerializationTime()
          + "\n");
      outStream.writeChars("    exec time: " + row.getExecutionTime() + "\n");
      outStream.writeChars("    deserial time: " + row.getDeserializationTime()
          + "\n");
      outStream.writeChars("    num blocks: " + row.getNumBlocks() + "\n");
      outStream.writeChars("    num threads: " + row.getNumThreads() + "\n");
    }

    // Get GPU results
    long totalHits = 0;
    List<Result> resultList = kernel.resultList.getList();
    for (Result result : resultList) {
      totalHits += result.hits;
    }
    double intermediate_results = 4.0 * totalHits
        / (m_calculationsPerThread * resultList.size());

    outStream.writeChars("totalHits: " + totalHits + "\n");
    outStream.writeChars("calculationsPerThread: " + m_calculationsPerThread
        + "\n");
    outStream.writeChars("results: " + resultList.size() + "\n");
    outStream.writeChars("calculationsTotal: " + m_calculationsPerThread
        * resultList.size() + "\n");
    outStream.close();

    // Send result to MasterTask
    peer.send(m_masterTask, new DoubleWritable(intermediate_results));
    peer.sync();
  }

  @Override
  public void cleanup(
      BSPPeer<NullWritable, NullWritable, Text, DoubleWritable, DoubleWritable> peer)
      throws IOException {

    if (peer.getPeerName().equals(m_masterTask)) {

      double pi = 0.0;

      int numMessages = peer.getNumCurrentMessages();

      DoubleWritable received;
      while ((received = peer.getCurrentMessage()) != null) {
        pi += received.get();
      }

      pi = pi / numMessages;
      peer.write(new Text("Estimated value of PI(3,14159265) using "
          + (numMessages * m_blockSize * m_gridSize * m_calculationsPerThread)
          + " points is"), new DoubleWritable(pi));
    }
  }

  static long divup(long x, long y) {
    if (x % y != 0) {
      // round up
      return ((x + y - 1) / y);
    } else {
      return x / y;
    }
  }

  static void printOutput(BSPJob job) throws IOException {
    FileSystem fs = FileSystem.get(job.getConfiguration());
    FileStatus[] files = fs.listStatus(FileOutputFormat.getOutputPath(job));
    for (int i = 0; i < files.length; i++) {
      if (files[i].getLen() > 0) {
        System.out.println("File " + files[i].getPath());
        FSDataInputStream in = fs.open(files[i].getPath());
        IOUtils.copyBytes(in, System.out, job.getConfiguration(), false);
        in.close();
      }
    }
    // fs.delete(FileOutputFormat.getOutputPath(job), true);
  }

  public static void main(String[] args) throws InterruptedException,
      IOException, ClassNotFoundException {
    // BSP job configuration
    HamaConfiguration conf = new HamaConfiguration();

    BSPJob job = new BSPJob(conf);
    // Set the job name
    job.setJobName("Rootbeer GPU PiEstimatior");
    // set the BSP class which shall be executed
    job.setBspClass(PiEstimatorGpuBSP.class);
    // help Hama to locale the jar to be distributed
    job.setJarByClass(PiEstimatorGpuBSP.class);

    job.setInputFormat(NullInputFormat.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(DoubleWritable.class);
    job.setOutputFormat(TextOutputFormat.class);
    FileOutputFormat.setOutputPath(job, TMP_OUTPUT);

    job.set("bsp.child.java.opts", "-Xmx4G");

    if (args.length > 0) {
      if (args.length == 2) {
        job.setNumBspTask(Integer.parseInt(args[0]));
        job.set("piestimator.iterations", args[1]);
      } else {
        System.out.println("Wrong argument size!");
        System.out.println("    Argument1=numBspTask");
        System.out.println("    Argument2=totalIterations");
        return;
      }
    } else {
      job.setNumBspTask(1);
      job.set("piestimator.iterations", "" + PiEstimatorGpuBSP.totalIterations);
    }
    LOG.info("NumBspTask: " + job.getNumBspTask());
    long totalIterations = Long.parseLong(job.get("piestimator.iterations"));
    LOG.info("TotalIterations: " + totalIterations);

    LOG.info("BlockSize: " + blockSize);
    LOG.info("GridSize: " + gridSize);

    job.set("piestimator.gridSize", "" + gridSize);
    job.set("piestimator.blockSize", "" + blockSize);

    long startTime = System.currentTimeMillis();
    if (job.waitForCompletion(true)) {
      printOutput(job);
      System.out.println("Job Finished in "
          + (System.currentTimeMillis() - startTime) / 1000.0 + " seconds");
    }
  }
}
