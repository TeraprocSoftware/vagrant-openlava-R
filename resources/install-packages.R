install.packages("RCurl", repos="http://cran.utstat.utoronto.ca/")
install.packages("XML", repos="http://cran.utstat.utoronto.ca/")
install.packages("BatchJobs", repos="http://cran.utstat.utoronto.ca/")
install.packages("snowfall", repos="http://cran.utstat.utoronto.ca/")
install.packages("devtools", repos="http://cran.utstat.utoronto.ca/")
install.packages("BBmisc", repos="http://cran.utstat.utoronto.ca/")
install.packages("DBI", repos="http://cran.utstat.utoronto.ca/")
install.packages("fail", repos="http://cran.utstat.utoronto.ca/")
install.packages("RSQLite", repos="http://cran.utstat.utoronto.ca/")
install.packages("sendmailR", repos="http://cran.utstat.utoronto.ca/")
install.packages("Rmpi", repos="http://cran.utstat.utoronto.ca/", 
                 configure.args =
                 c("--with-Rmpi-include=/usr/local/openmpi/include/",
                   "--with-Rmpi-libpath=/usr/local/openmpi/lib/",
                   "--with-Rmpi-type=OPENMPI"))
install.packages(c("snow","snowfall"), repos="http://cran.utstat.utoronto.ca/")
install.packages("testthat", repos="http://cran.utstat.utoronto.ca/")
install.packages("parallelMap", repos="http://cran.utstat.utoronto.ca/")
install.packages("mlr", repos="http://cran.utstat.utoronto.ca/")
install.packages("randomForest", repos="http://cran.utstat.utoronto.ca/")
source("http://bioconductor.org/biocLite.R")
biocLite("BiocParallel")
biocLite("GEOquery")
