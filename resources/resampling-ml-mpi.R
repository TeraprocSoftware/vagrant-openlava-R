library("BatchJobs")

setwd("~/examples")

conf = BatchJobs:::getBatchJobsConf()
conf$cluster.functions = makeClusterFunctionsOpenLava("../rmpi-batch.tmpl")

# this is the function that represents one MPI job
mpi.function <- function(i) {
  library("parallelMap")
  library("mlr")
  library("Rmpi")
  
  setwd("~/examples")

  slaveno <- mpi.universe.size() - 1
  if (slaveno < 1) {
    slaveno <- 1
  }
  
  parallelStartMPI(slaveno)
  
  lrn = makeLearner("classif.randomForest")
  adult = read.table("data/adult.test",
                   sep=",",header=F,col.names=c("age", "type_employer", "fnlwgt", "education",
                                                "education_num","marital", "occupation", "relationship", "race","sex",
                                                "capital_gain", "capital_loss", "hr_per_week","country", "income"),
                   fill=FALSE,strip.white=T
  )
  adult.task = makeClassifTask(data = adult, target = "education")
  rdesc = makeResampleDesc("CV", iters = slaveno)
  system.time(res <- resample(lrn, adult.task, rdesc))
  res

  parallelStop()
}


# Make registry for one OpenLava MPI job
reg <- makeRegistry(id="TPcalc")
ids <- batchMap(reg, fun=mpi.function, 1)
print(ids)
print(reg)

# submit the job to the OpenLava cluster, specify four cores for MPI parallelization
start.time <- Sys.time()
done <- submitJobs(reg, np=4)
waitForJobs(reg)

end.time <- Sys.time()
time.taken <- end.time - start.time
print(time.taken)

# clean up after the batch job by removing the registry
removeRegistry(reg,"no")