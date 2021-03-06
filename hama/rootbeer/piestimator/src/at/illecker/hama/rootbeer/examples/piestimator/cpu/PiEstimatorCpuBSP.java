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
package at.illecker.hama.rootbeer.examples.piestimator.cpu;

import java.io.IOException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IOUtils;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hama.HamaConfiguration;
import org.apache.hama.bsp.BSP;
import org.apache.hama.bsp.BSPJob;
import org.apache.hama.bsp.BSPJobClient;
import org.apache.hama.bsp.BSPPeer;
import org.apache.hama.bsp.ClusterStatus;
import org.apache.hama.bsp.FileOutputFormat;
import org.apache.hama.bsp.NullInputFormat;
import org.apache.hama.bsp.TextOutputFormat;
import org.apache.hama.bsp.sync.SyncException;

import at.illecker.hama.rootbeer.examples.piestimator.gpu.LinearCongruentialRandomGenerator;

/**
 * @author PiEstimator Monte Carlo computation of pi
 *         http://de.wikipedia.org/wiki/Monte-Carlo-Algorithmus
 * 
 *         Generate random points in the square [-1,1] X [-1,1]. The fraction of
 *         these that lie in the unit disk x^2 + y^2 <= 1 will be approximately
 *         pi/4.
 */

public class PiEstimatorCpuBSP extends
    BSP<NullWritable, NullWritable, Text, DoubleWritable, LongWritable> {
  private static final Log LOG = LogFactory.getLog(PiEstimatorCpuBSP.class);
  private static final Path TMP_OUTPUT = new Path(
      "output/hama/rootbeer/examples/piestimator/CPU-"
          + System.currentTimeMillis());

  public static final String CONF_DEBUG = "piestimator.cpu.debug";
  public static final String CONF_ITERATIONS = "piestimator.iterations";

  private static final long totalIterations = 1433600000L;
  // Long.MAX = 9223372036854775807

  private String m_masterTask;
  private long m_iterations;
  private long m_calculationsPerBspTask;
  private boolean m_isDebuggingEnabled;

  @Override
  public void setup(
      BSPPeer<NullWritable, NullWritable, Text, DoubleWritable, LongWritable> peer)
      throws IOException {

    // Choose one as a master
    this.m_masterTask = peer.getPeerName(peer.getNumPeers() / 2);

    this.m_isDebuggingEnabled = peer.getConfiguration().getBoolean(CONF_DEBUG,
        false);

    this.m_iterations = Long.parseLong(peer.getConfiguration().get(
        CONF_ITERATIONS));

    m_calculationsPerBspTask = divup(m_iterations, peer.getNumPeers());
  }

  @Override
  public void bsp(
      BSPPeer<NullWritable, NullWritable, Text, DoubleWritable, LongWritable> peer)
      throws IOException, SyncException, InterruptedException {

    long seed = System.currentTimeMillis();
    LinearCongruentialRandomGenerator m_lcg = new LinearCongruentialRandomGenerator(
        seed);

    long hits = 0;
    for (long i = 0; i < m_calculationsPerBspTask; i++) {
      double x = 2.0 * m_lcg.nextDouble() - 1.0;
      double y = 2.0 * m_lcg.nextDouble() - 1.0;

      if ((Math.sqrt(x * x + y * y) < 1.0)) {
        hits++;
      }
    }

    // Send result to MasterTask
    peer.send(m_masterTask, new LongWritable(hits));
    peer.sync();
  }

  @Override
  public void cleanup(
      BSPPeer<NullWritable, NullWritable, Text, DoubleWritable, LongWritable> peer)
      throws IOException {

    if (peer.getPeerName().equals(m_masterTask)) {

      int numMessages = peer.getNumCurrentMessages();
      
      long totalHits = 0;
      LongWritable received;
      while ((received = peer.getCurrentMessage()) != null) {
        totalHits += received.get();
      }

      double pi = 4.0 * totalHits / (m_calculationsPerBspTask * numMessages);

      // DEBUG
      if (m_isDebuggingEnabled) {
        // Write log to dfs
        BSPJob job = new BSPJob((HamaConfiguration) peer.getConfiguration());
        FileSystem fs = FileSystem.get(peer.getConfiguration());
        FSDataOutputStream outStream = fs.create(new Path(FileOutputFormat
            .getOutputPath(job), peer.getTaskId() + ".log"));

        outStream.writeChars("BSP=PiEstimatorGpuBSP,Iterations=" + m_iterations
            + "\n");

        outStream.writeChars("totalHits: " + totalHits + "\n");
        outStream.writeChars("numMessages: " + numMessages + "\n");
        outStream.writeChars("calculationsPerBspTask: "
            + m_calculationsPerBspTask + "\n");
        outStream.writeChars("calculationsTotal: "
            + (m_calculationsPerBspTask * numMessages) + "\n");
        outStream.close();
      }

      peer.write(new Text("Estimated value of PI(3,14159265) using "
          + (m_calculationsPerBspTask * numMessages)
          // + (peer.getNumPeers() * m_threadCount * m_iterations)
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

  public static BSPJob createPiEstimatorCpuBSPConf(Path outPath)
      throws IOException {
    return createPiEstimatorCpuBSPConf(new HamaConfiguration(), outPath);
  }

  public static BSPJob createPiEstimatorCpuBSPConf(
      HamaConfiguration initialConf, Path outPath) throws IOException {

    BSPJob job = new BSPJob(initialConf);
    // Set the job name
    job.setJobName("Rootbeer CPU PiEstimatior");
    // set the BSP class which shall be executed
    job.setBspClass(PiEstimatorCpuBSP.class);
    // help Hama to locale the jar to be distributed
    job.setJarByClass(PiEstimatorCpuBSP.class);

    job.setInputFormat(NullInputFormat.class);

    job.setOutputFormat(TextOutputFormat.class);
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(DoubleWritable.class);
    FileOutputFormat.setOutputPath(job, outPath);

    job.set("bsp.child.java.opts", "-Xmx4G");

    return job;
  }

  public static void main(String[] args) throws InterruptedException,
      IOException, ClassNotFoundException {

    BSPJob job = createPiEstimatorCpuBSPConf(TMP_OUTPUT);

    BSPJobClient jobClient = new BSPJobClient(job.getConfiguration());
    ClusterStatus cluster = jobClient.getClusterStatus(true);

    if (args.length > 0) {
      if (args.length == 2) {
        job.setNumBspTask(Integer.parseInt(args[0]));
        job.set(CONF_ITERATIONS, args[1]);
      } else {
        System.out.println("Wrong argument size!");
        System.out.println("    Argument1=numBspTask");
        System.out.println("    Argument3=totalIterations");
        return;
      }
    } else {
      job.setNumBspTask(cluster.getMaxTasks());
      job.set(CONF_ITERATIONS, "" + PiEstimatorCpuBSP.totalIterations);
    }

    LOG.info("NumBspTask: " + job.getNumBspTask());
    long totalIterations = Long.parseLong(job.get(CONF_ITERATIONS));
    LOG.info("TotalIterations: " + totalIterations);
    LOG.info("IterationsPerBspTask: " + totalIterations / job.getNumBspTask());
    job.setBoolean(CONF_DEBUG, true);
    
    long startTime = System.currentTimeMillis();
    if (job.waitForCompletion(true)) {
      printOutput(job);
      System.out.println("Job Finished in "
          + (System.currentTimeMillis() - startTime) / 1000.0 + " seconds");
    }
  }
}
