#!/usr/bin/Rscript
library(rjson)
library(reshape2)
suppressPackageStartupMessages(library(sqldf))
library(ggplot2)

# Functions
# List append
lappend <- function (lst, ...) {
  lst <- c(lst, list(...))
  return(lst)
}

args <- commandArgs(trailingOnly = TRUE)
if (is.na(args[1])) {
  stop("Argument CaliperResult JsonFile is missing! (~/.caliper/results)")
}

# Load result file
caliperJsonFile <- args[1]
# caliperJsonFile <- "results/matrixmultiplication/at.illecker.hadoop.rootbeer.examples.matrixmultiplication.MatrixMultiplicationBenchmark.2013-06-23T13:37:02Z.json"
# caliperJsonFile <- "results/hama/piestimator_hybrid/at.illecker.hama.hybrid.examples.piestimator.PiEstimatorHybridBenchmark.2013-08-27T08:29:35Z.json"
caliperResult <- NULL
caliperResult <- fromJSON(file=caliperJsonFile)
if (is.null(caliperResult)) {
  message <- paste("Json File was not found!",caliperJsonFile)
  stop(message)
}

scenarioTable <- NULL
measurementResults <-list()

# Loop over all scenarios and build measurements
for (scenarioIndex in 1:length(caliperResult)) {
  
  scenarioTableRow <- data.frame(scenario=scenarioIndex)
  scenario <- caliperResult[[scenarioIndex]]
  #length(scenario)
  
  # Scenario ID
  scenarioId <- scenario[1]
  
  # Add id
  scenarioTableRow <- data.frame(scenarioTableRow,data.frame(id=scenarioId))

  # Scenario Run informations
  scenarioRun <- scenario[2]
  # Add startTime
  scenarioTableRow <- data.frame(scenarioTableRow,data.frame(StartTime=scenarioRun$run$startTime))

  # Scenario Instrument specification
  scenarioInstrumentSpec <- scenario[3]
  # Add Instrument className
  scenarioTableRow <- data.frame(scenarioTableRow,data.frame(Instrument=scenarioInstrumentSpec$instrumentSpec$className))
  # Add measurements if not null
  if (is.null(scenarioInstrumentSpec$instrumentSpec$options$measurements)) {
    message <- paste("Warning: Scenario",scenarioId,"does not contain instrumentSpec measurements information. Skipping this scenario!\n")
    cat(message)
    next; # skip scenario continue
    # scenarioTableRow <- data.frame(scenarioTableRow,data.frame(Measurements=0))  
  } else {
    scenarioTableRow <- data.frame(scenarioTableRow,data.frame(Measurements=scenarioInstrumentSpec$instrumentSpec$options$measurements))  
  }
  # Add warmup
  if (is.null(scenarioInstrumentSpec$instrumentSpec$options$warmup)) {
    message <- paste("Warning: Scenario",scenarioId,"does not contain instrumentSpec warmup information!\n")
    cat(message)
    scenarioTableRow <- data.frame(scenarioTableRow,data.frame(Warmup=0))
  } else {
    scenarioTableRow <- data.frame(scenarioTableRow,data.frame(Warmup=scenarioInstrumentSpec$instrumentSpec$options$warmup))
  }
  
  # Scenario properties
  scenarioProperties <- scenario[4]$scenario
  
  # Scenario Host informations
  scenarioHost <- scenarioProperties[1]
  # Add host.availableProcessors
  scenarioTableRow <- data.frame(scenarioTableRow,data.frame(AvailableProcessors=scenarioHost$host$properties$host.availableProcessors))
  # Add os.name
  scenarioTableRow <- data.frame(scenarioTableRow,data.frame(OS=scenarioHost$host$properties$os.name))
  # Add os.arch
  scenarioTableRow <- data.frame(scenarioTableRow,data.frame(OS_Arch=scenarioHost$host$properties$os.arch))

  # Scenario VM specifications
  #scenarioVmSpec <- scenarioProperties[2]
  #javaName <- scenarioVmSpec$vmSpec$properties$java.runtime.name
  #javaVersion <- scenarioVmSpec$vmSpec$properties$java.runtime.version
  #scenarioVmSpec$vmSpec$options
  
  # Scenario Benchmark specifications
  scenarioBenchmarkSpec <- scenarioProperties[3]$benchmarkSpec
  # Add className
  scenarioTableRow <- data.frame(scenarioTableRow,data.frame(ClassName=scenarioBenchmarkSpec$className))
  # Add methodName
  scenarioTableRow <- data.frame(scenarioTableRow,data.frame(MethodName=scenarioBenchmarkSpec$methodName))
  
  parameters <- scenarioBenchmarkSpec$parameters
  allParameters <- NULL
  # Get Parameters of scenarioBenchmarkSpec
  for (parameterIndex in 1:length(parameters)) {
    
    parameters.T <- t(melt(parameters[parameterIndex]))
    colnames(parameters.T) <- parameters.T[2,] 
    parameterName <- parameters.T[2,]
    parameterValue <- parameters.T[1,]
    
    parameter <- data.frame(parameterValue)
    colnames(parameter) <- parameterName
    
    if (is.null(allParameters)) {
      allParameters <- paste(parameterName,"=",parameterValue, sep="")
    } else {
      allParameters <- paste(allParameters,"\n",parameterName,"=",parameterValue, sep="")
    }
    
    scenarioTableRow <- data.frame(scenarioTableRow,parameter)
  }
  scenarioTableRow <- data.frame(scenarioTableRow,data.frame(AllParameters=allParameters))
  
  # Add scenarioTableRow to scenarioTable
  if (is.null(scenarioTable)) {
    scenarioTable <- scenarioTableRow
  } else {
    scenarioTable <- rbind(scenarioTable,scenarioTableRow)  
  }


  # Get Measurements of scenario
  measurements <- scenario[5]$measurements
  for (measurementIndex in 1:length(measurements)) {
  
    measurement <- measurements[[measurementIndex]]
    
    value <- measurement$value
    weight <- measurement$weight
    magnitude <- value$magnitude
    unit <- value$unit
  
    newMeasurementRow <- c(scenario=scenarioIndex,measurement=measurementIndex,magnitude=magnitude,unit=unit,weight=weight)
    measurementResults <- lappend(measurementResults, newMeasurementRow)
  }
}


## Measurement Table
# Create table from vectors
measurementTable <- data.frame(measurementResults)
# Transpose table
measurementTable.T <- t(measurementTable)
# Set row names to index
row.names(measurementTable.T) <- 1:nrow(measurementTable.T)
measurementTable <- measurementTable.T
measurementTable <- data.frame(measurementTable)

# Convert Strings to Numeric
measurementTable <- transform(measurementTable,scenario = as.numeric(as.character(measurementTable$scenario)))
measurementTable <- transform(measurementTable,measurement = as.numeric(as.character(measurementTable$measurement)))
measurementTable <- transform(measurementTable,magnitude = as.numeric(as.character(measurementTable$magnitude)))
measurementTable <- transform(measurementTable,weight = as.numeric(as.character(measurementTable$weight)))

scenarioTable <- transform(scenarioTable,Measurements = as.numeric(as.character(scenarioTable$Measurements)))
scenarioTable <- transform(scenarioTable,AvailableProcessors = as.numeric(as.character(scenarioTable$AvailableProcessors)))


## Cleanup
rm(scenario)
rm(scenarioIndex)
rm(measurementIndex)
rm(measurementResults)
rm(newMeasurementRow)
rm(measurement)
rm(measurements)
rm(measurementTable.T)
rm(value)
rm(magnitude)
rm(unit)
rm(parameterIndex)
rm(parameterName)
rm(parameterValue)
rm(allParameters)
rm(parameter)
rm(parameters)
rm(parameters.T)
rm(scenarioTableRow)
rm(scenarioBenchmarkSpec)
rm(scenarioHost)
rm(scenarioId)
rm(scenarioInstrumentSpec)
rm(scenarioProperties)
rm(scenarioRun)

# add weighted magnitude
measurementTable["weighted_magnitude"] <- NA
measurementTable$weighted_magnitude <- measurementTable$magnitude / measurementTable$weight

benchmarkTable <- merge(x = measurementTable, y = scenarioTable, by = "scenario", all.x=TRUE)
#benchmarkTable <- sqldf('SELECT * FROM measurementTable JOIN scenarioTable USING(scenario)')

cat("Info: BenchmarkTable Execution Times\n")
sqldf('SELECT scenario,magnitude,unit,weight,weighted_magnitude,AllParameters FROM benchmarkTable')

benchmarkTableAvg <- sqldf('SELECT scenario,avg(magnitude/weight) as magnitude,unit,AllParameters FROM benchmarkTable GROUP BY scenario')
cat("BenchmarkTable Average Execution Time avg(magnitude/weight)\n")
benchmarkTableAvg
#str(benchmarkTableAvg)

#cat("Info: Summary of benchmarkTable\n")
#summary(benchmarkTable)


title <- paste("Benchmark of ", benchmarkTable$ClassName[1],
               #".",benchmarkTable$MethodName[1],
               " with ",benchmarkTable$Measurements[1],
               " measurements ", sep="")

xaxisDesc <- paste("Parameter", sep="")
if (!is.na(args[3])) {
  xaxisDesc <- paste("Parameter", args[3])
}

if (is.na(args[2])) {
  yaxisDesc <- paste("Time (",benchmarkTableAvg$unit[1],")", sep="")
} else {
  yaxisDesc <- paste("Time", sep="")
  if (!is.na(args[4])) {
    yaxisDesc <- paste("Time", args[4])
  }
}

# Align magnitude
if (!is.na(args[2])) {
  power <- as.numeric(args[2])
  benchmarkTableAvgAligned <- within(benchmarkTableAvg, magnitude <- magnitude / 10^power)
  benchmarkTableAvg <- benchmarkTableAvgAligned
  
  benchmarkTableAligned <- within(benchmarkTable, weighted_magnitude  <- weighted_magnitude  / 10^power)
  benchmarkTable <- benchmarkTableAligned
}

# Generate Bar chart of average data
ggplot(benchmarkTableAvg,aes(x=AllParameters,y=magnitude,fill=factor(scenario))) + 
  geom_bar(stat="identity",color="black") +
  xlab(xaxisDesc) +
  ylab(yaxisDesc) +
  ggtitle(title) +
  theme(legend.position = "none")

outputfile <- paste(caliperJsonFile,"_avg_barplot.pdf", sep="")
ggsave(file=outputfile, scale=2)

message <- paste("Info: Saved Barplot in",outputfile,"\n")
cat(message)

# Generate Geom Line plot of average data
if (!is.na(args[5]) && args[5]=='true') {
  ggplot(benchmarkTableAvg, aes(x=AllParameters,y=magnitude,color="red",group=unit)) + 
    geom_point(size=5) + 
    geom_line() +
    xlab(xaxisDesc) +
    ylab(yaxisDesc) +
    ggtitle(title) +
    theme(legend.position = "none")

  outputfile <- paste(caliperJsonFile,"_geom_line.pdf", sep="")
  ggsave(file=outputfile, scale=2)

  message <- paste("Info: Saved GeomLine Plot in ",outputfile,"\n",sep="")
  cat(message)
}

# Generate Box plot
#benchmarkTable
#str(benchmarkTable)
ggplot(benchmarkTable, aes(x=AllParameters,y=weighted_magnitude,fill=factor(scenario))) + 
  geom_boxplot(outlier.colour = "red", outlier.size = 5) +
  xlab(xaxisDesc) +
  ylab(yaxisDesc) +
  ggtitle(title) +
  theme(legend.position = "none")

outputfile <- paste(caliperJsonFile,"_boxplot.pdf", sep="")
ggsave(file=outputfile, scale=2)

message <- paste("Info: Saved Boxplot in",outputfile,"\n")
cat(message)


# Generate CPU + GPU plot
if (!is.na(args[6]) && args[6]=='true' && !is.na(args[7])) {
  power <- as.numeric(args[2])
  customVariable <- as.character(args[7])
  #cat(paste("Generate geom_line plot and normalize magnitude with 10^",power,"\n",sep=""))
  
  benchmarkTableAvgScenarioGroup <- fn$sqldf('SELECT scenario,$customVariable,(avg(magnitude/weight) / power(10,$power)) as magnitude,type FROM benchmarkTable GROUP BY scenario')
  #benchmarkTableAvgScenarioGroup <- transform(benchmarkTableAvgScenarioGroup,customVariable = as.numeric(as.character(benchmarkTableAvgScenarioGroup$customVariable)))
  #benchmarkTableAvgScenarioGroup
  # str(benchmarkTableAvgScenarioGroup)
  #benchmarkTableAvgScenarioGroup <- within(benchmarkTableAvgScenarioGroup, iterations <- n * constant)
  ggplot(benchmarkTableAvgScenarioGroup, aes_string(x=customVariable,y="magnitude",colour="type",group="type")) + 
    geom_point(size=5) + 
    geom_line() +
    xlab(paste(customVariable,args[3])) +
    ylab(paste("Time",args[4])) +
    ggtitle(title) +
    theme(legend.position = "bottom")
  
  outputfile <- paste(caliperJsonFile, "_", customVariable, "_cpu_gpu_geom_line.pdf", sep="")
  ggsave(file=outputfile, scale=1.5)
  message <- paste("Info: Saved CPU+GPU GeomLine Plot in ",outputfile," (normalized magnitude 10^",power,")\n",sep="")
  cat(message)
}

# Generate Speedup and Efficiency plot
if (!is.na(args[8]) && args[8]=='true') {
  power <- as.numeric(args[2])
  
  benchmarkTableAvgScenarioGroup <- fn$sqldf('SELECT scenario,n,(avg(magnitude/weight) / power(10,$power)) as magnitude,bspTaskNum FROM benchmarkTable GROUP BY scenario')
  # convert bspTaskNum col to numeric
  benchmarkTableAvgScenarioGroup$bspTaskNum <- as.numeric(benchmarkTableAvgScenarioGroup$bspTaskNum)
  # get magnitude of bspTaskNum=1
  magnitude_bspTaskNum1 <- benchmarkTableAvgScenarioGroup[benchmarkTableAvgScenarioGroup$bspTaskNum==1,]$magnitude
  # add new col of magnitude of bspTaskNum=1
  benchmarkTableAvgScenarioGroup$seq_magnitude <- NA
  benchmarkTableAvgScenarioGroup$seq_magnitude[is.na(benchmarkTableAvgScenarioGroup$seq_magnitude)] <- magnitude_bspTaskNum1
  # add speedup column
  benchmarkTableAvgScenarioGroup <- within(benchmarkTableAvgScenarioGroup, speedup <- seq_magnitude / magnitude)
  # add efficiency column
  benchmarkTableAvgScenarioGroup <- within(benchmarkTableAvgScenarioGroup, efficiency <- speedup / bspTaskNum)
  # add group column
  benchmarkTableAvgScenarioGroup$type <- 1
  
  # Save speedup plot 
  ggplot(benchmarkTableAvgScenarioGroup, aes(x=bspTaskNum,y=speedup,colour=type,group=type)) + 
     geom_point(size=5) + 
     geom_line() +
     xlab(paste("bspTaskNum")) +
     ylab(paste("speedup")) +
     ggtitle(title) +
     theme(legend.position = "none")
  outputfile <- paste(caliperJsonFile,"_speedup_geom_line.pdf", sep="")
  ggsave(file=outputfile, scale=1.5)
  message <- paste("Info: Saved Speedup GeomLine Plot in ",outputfile," (normalized magnitude 10^",power,")\n",sep="")
  cat(message)
  
  # Save efficiency plot 
  ggplot(benchmarkTableAvgScenarioGroup, aes(x=bspTaskNum,y=efficiency,colour=type,group=type)) + 
    geom_point(size=5) + 
    geom_line() +
    xlab(paste("bspTaskNum")) +
    ylab(paste("efficiency")) +
    ggtitle(title) +
    theme(legend.position = "none")
  outputfile <- paste(caliperJsonFile,"_efficiency_geom_line.pdf", sep="")
  ggsave(file=outputfile, scale=1.5)
  message <- paste("Info: Saved Efficiency GeomLine Plot in ",outputfile," (normalized magnitude 10^",power,")\n",sep="")
  cat(message)
  
  # prepare data for plot speedup and efficiency together
  # speedupEfficiencyTable <- data.frame(bspTaskNum = benchmarkTableAvgScenarioGroup$bspTaskNum, value = benchmarkTableAvgScenarioGroup$speedup, type = 'speedup')
  # speedupEfficiencyTable <- rbind(speedupEfficiencyTable, data.frame(bspTaskNum = benchmarkTableAvgScenarioGroup$bspTaskNum, value = benchmarkTableAvgScenarioGroup$efficiency, type = 'efficiency'))
  
  # ggplot(speedupEfficiencyTable, aes(x=bspTaskNum,y=value,colour=type,group=type)) + 
  #   geom_point(size=5) + 
  #   geom_line() +
  #   xlab(paste("bspTaskNum")) +
  #   ylab(paste("")) +
  #   ggtitle(title) +
  #   theme(legend.position = "bottom")
  
  # outputfile <- paste(caliperJsonFile,"_speedup_efficiency_geom_line.pdf", sep="")
  # ggsave(file=outputfile, scale=1.5)
  # message <- paste("Info: Saved Speedup and Efficiency GeomLine Plot in ",outputfile," (normalized magnitude 10^",power,")\n",sep="")
  # cat(message)
}

# Delete temporary created plot file
unlink("Rplots.pdf")
