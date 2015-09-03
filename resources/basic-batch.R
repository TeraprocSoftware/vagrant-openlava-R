library(BatchJobs)

setwd("/vagrant/share") 
conf = BatchJobs:::getBatchJobsConf()
conf$cluster.functions = makeClusterFunctionsOpenLava("/vagrant/resources/ol.tmpl") # specify job template file 
reg = makeRegistry(id = "BatchJobsExampleOpenLava")

f = function(x) Sys.sleep(x) # algorithm function. user can replace sleep to be the real calculation here.                
batchMap(reg, f, 11:14) # specify data blocks for parallel
submitJobs(reg)
# submitJobs(reg, resources=list(queue="research-rh6"))
showStatus(reg)
waitForJobs(reg)
showStatus(reg)
removeRegistry(reg, "no")

