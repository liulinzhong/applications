###############################################################################
##### MatrixMultiplication based on Mahout Example                        #####
###############################################################################

# Use Apache Ant to build and run example

# Clean all files
ant clean

# Build GPU jar file
ant jar-gpu

# Build CPU jar file
ant jar-cpu

# Build Benchmark jar file
ant jar-bench

###############################################################################

# Submit GPU Task to Hadoop
ant run-gpu -DnumRows='--numRows 100' -DnumCols='--numCols 100' 
  [-Ddebug='--debug true']

# Submit GPU native emulated Task to Hadoop
ant run-gpu-nemu -DnumRows='--numRows 100' -DnumCols='--numCols 100' 
  [-Ddebug='--debug true']

# Submit GPU Java emulated Task to Hadoop
ant run-gpu-jemu -DnumRows='--numRows 100' -DnumCols='--numCols 100' 
  [-Ddebug='--debug true']

# Submit CPU Task to Hadoop
ant run-cpu -DnumRows='--numRows 100' -DnumCols='--numCols 100' 
  [-Ddebug='--debug true']

# Run Benchmark
ant run-bench -DbenchTimeLimit='--time-limit 300s' \
  -DbenchInstrument='--instrument macro' \
  -DbenchMacroMeasurements='-Cinstrument.macro.options.measurements=5' \
  -DbenchMacroWarmup='-Cinstrument.macro.options.warmup=30s'
  [-DbenchTrials='--trials 1']

###############################################################################