vagrant-Openlava-R on Ubuntu-14.04
================================

# Introduction

Vagrant project to spin up a cluster of 6 virtual machines with OpenLava v3.0, OpenMPI v1.8.8, Docker v1.7.1, RStudio v0.98 and latest R environment (BatchJobs, BiocParallel and RMPI packages).

1. olnode1 : Openlava master, RStudio server, R, OpenMPI
2. olnode2 : Openlava slave with R, OpenMPI
3. olnode3 : Openlava slave with R, OpenMPI
4. olnode4 : Openlava slave with R, OpenMPI
5. olnode5 : Openlava slave with R, OpenMPI
6. olnode6 : Openlava slave with R, OpenMPI

TODO: OpenLDAP for user management
TODO: OpenLava+Docker+R

# Getting Started

1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. [Download and install Vagrant](http://www.vagrantup.com/downloads.html).
3. Run ```vagrant box add ubuntu https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box```
4. Git clone this project, and change directory (cd) into this project (directory).
5. Run ```vagrant up``` to create the VM.
6. Run ```vagrant ssh``` to get into your VM. The VM name in vagrant is olnode1, olnode2 ... olnoden. While the ip of VMs depends on the scale of your OpenLava cluster. If it is less then 10, the IP will be 10.211.59.101, .... 10.211.59.10n. Or you could run ```ssh``` directly with ip of VMs and username/password of root/vagrant.
7. Run ```vagrant destroy``` when you want to destroy and get rid of the VM.
8. The directory of /vagrant is mounted in each VM by vagrant if you want to access host machine from VM. You could also use win-sshfs if you want to access the local file system of VM from host machine. Please refer to http://code.google.com/p/win-sshfs/ for details.

Some gotcha's.

* Make sure you download Vagrant v1.7.1 or higher and VirtualBox 4.3.20 or higher with extension package
* Make sure when you clone this project, you preserve the Unix/OSX end-of-line (EOL) characters. The scripts will fail with Windows EOL characters. If you are using Windows, please make sure the following configuration is configured in your .gitconfig file which is located in your home directory ("C:\Users\yourname" in Win7 and after, and "C:\Documents and Settings\yourname" in WinXP). Refer to http://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration for details of git configuration.
```
[core]
    autocrlf = false
    safecrlf = true
```
* Make sure you have 10Gb of free memory for the VMs. You may change the Vagrantfile to specify smaller memory requirements.
* This project has NOT been tested with the other providers such as VMware for Vagrant.
* You may change the script (common.sh) to point to a different location for OpenMPI and so on to be downloaded from.

# Advanced Stuff

If you have the resources (CPU + Disk Space + Memory), you may modify Vagrantfile to have even more OpenLava slave. Just find the line that says "numNodes = 6" in Vagrantfile and increase that number. The scripts should dynamically provision the additional slaves for you.

A default user demo with password of demo is created in all the nodes. This user could be used to submit OpenLava job and R job.

# Start OpenLava/R Environment

## Manage OpenLava

OpenLava services have been started by Vagrant. Refer to http://www.openlava.org/ for how to manage OpenLava. Since the directory of $HOMEDIR_GIT_THISPROJECT is mounted in all nodes as /vagrant, user could use /vagrant/share as share file directory to keep R jobs and data.

By default, two queues are created. The batch queue is for batch R jobs, while the interactive queue is for interactive jobs.

## Test OpenLava/Docker


## Test OpenLava/MPI

Run following command to verify OpenLava/MPI. Refer to /usr/local/openmpi/examples/ for more example of OpenMPI.

```
bsub -n 2 "/opt/openlava-2.2/bin/openmpi-mpirun -np 2 /usr/local/openmpi/examples/hello_c"
```

## Build R BatchJobs Packages

makeR in  https://github.com/tudo-r/makeR.git is a tools to help build R packages. I have not figure out how to configure the git submodule mentioned in its README, but you could always clone makeR and copy it into your R packge root directory, and then in the root directory Run following command

```
make -f ./makeR/Makefile package
```

or 

```
make -f ./makeR/Makefile install
```

## Test OpenLava/RBatch

OpenLava/RBatch integration is using R packages of BatchJobs and BiocParallel. Refer to https://github.com/tudo-r/BatchJobs/wiki/Configuration for details of configuration of BatchJobs.

Run following command to verify OpenLava/R. If the command has been run before, please make sure all the files in /vagrant/share/GSM917672 have been cleaned up, and make sure the "PWD" is /vagrant/share as BiocParallel generates temp R scripts in current working directory and submit it as Batch Jobs. 

```
cd /vagrant/share
R CMD BATCH /vagrant/resources/basic-batch.R /vagrant/share/test.log
```

## Test OpenLava/RMPI

OpenLava/RMPI integration is using R packages of RMPI, snow and parallel. Refer to http://acmmac.acadiau.ca/intro_Rmpi/intro_to_Rmpi.html for an introduction how to run RMPI script.

Run following command to verify OpenLava/RMPI. Check the working directory for the result of R script. 

```
bsub -n 3 "/opt/openlava-2.2/bin/openmpi-mpirun -np 1 R --slave CMD BATCH /vagrant/resources/rmpi_hello.R"
bsub -n 3 "/opt/openlava-2.2/bin/openmpi-mpirun -np 1 R --slave CMD BATCH /vagrant/resources/brute_force.R"
bsub -n 3 "/opt/openlava-2.2/bin/openmpi-mpirun -np 1 R --slave CMD BATCH /vagrant/resources/snow-test.R"
```

## Manage RStudio

RStudio services have been started by Vagrant. Access RStudio by http://10.211.59.101:8787

Refer to https://stat.ethz.ch/R-manual/R-devel/library/base/html/EnvVar.html for how to configure environment for R session.

Refer to https://support.rstudio.com/hc/en-us/articles/200552316-Configuring-the-Server for how to configure RStudio Server.

## Install R Development Environment

Refer to http://www.walware.de/goto/statet for how to install StatET R plug-ins for the Eclipse IDE

# Reference

http://pubs.sciepub.com/ajams/2/4/9/
http://cran.r-project.org/web/views/HighPerformanceComputing.html
http://acmmac.acadiau.ca/intro_Rmpi/intro_to_Rmpi.html
https://bioinfomagician.wordpress.com/2013/11/25/mpi-tutorial-for-r-rmpi/
http://www.umbc.edu/hpcf/resources-tara-2010/how-to-run-R.html
https://rdatamining.wordpress.com/2012/05/06/online-resources-for-handling-big-data-and-parallel-computing-in-r/

http://star.mit.edu/cluster/docs/0.93.3/guides/sge.html
http://blog.nguyenvq.com/blog/category/r/page/2/
http://talby.rcs.manchester.ac.uk/~ri/_notes_sge/par_envs_and_integration.html
http://www.softpanorama.org/HPC/Grid_engine/parallel_environment.shtml
https://www.open-mpi.org/faq/?category=sge
http://linux.die.net/man/5/sge_pe

