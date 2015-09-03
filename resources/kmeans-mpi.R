#!/usr/bin/env Rscript
#
# kmeans-mpi.R - Sample script that performs a kmeans analysis on the generated dataset.csv file
#

library("BatchJobs")
library(ggplot2)

setwd("/vagrant/share") 

conf = BatchJobs:::getBatchJobsConf()
conf$cluster.functions = makeClusterFunctionsOpenLava("/vagrant/resources/ol.tmpl")

# this is the function that represents one MPI job
mpi.function <- function(i) {
  library(parallel)
  library(Rmpi)
  
  slaveno <- mpi.universe.size() - 1
  if (slaveno < 1) {
    slaveno <- 1
  }
  parallel.function <- function(i) {
    set.seed(i)
    data <- read.csv('/vagrant/share/data/dataset.csv')
    result <- kmeans(data, centers=5, nstart=i)
    result
  }
  
  cl <- makeCluster(slaveno, type = "MPI")
  results <- clusterApply(cl, c(60,60), fun=parallel.function)
  
  temp.vector <- sapply( results, function(result) { result$tot.withinss } )
  result <- results[[which.min(temp.vector)]]
  saveRDS(result, file = "/vagrant/share/data/kmeans-result.rds")
  stopCluster(cl)
  result
}

# Make registry for one OpenLava MPI job
reg <- makeRegistry(id="TPcalc")
ids <- batchMap(reg, fun=mpi.function, 1)
print(ids)
print(reg)

# submit the job to the OpenLava cluster, specify four cores for MPI parallelization
start.time <- Sys.time()
done <- submitJobs(reg, np=3)
waitForJobs(reg)

end.time <- Sys.time()
time.taken <- end.time - start.time
print(time.taken)

# Load results of the OpenLava MPI job
final_result <- readRDS("/vagrant/share/data/kmeans-result.rds")

# show the results
print(final_result$centers)

# plot the results
data <- read.csv('/vagrant/share/dataset.csv')
data$cluster = factor(final_result$cluster)
centers = as.data.frame(final_result$centers)
plot = ggplot(data=data, aes(x=x, y=y, color=cluster )) + geom_point() + geom_point(data=centers, aes(x=x,y=y, color='Center')) + geom_point(data=centers, aes(x=x,y=y, color='Center'), size=52, alpha=.3, show_guide=FALSE)
print(plot)

# clean up after the batch job by removing the registry
removeRegistry(reg,"no")
