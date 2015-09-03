#!/bin/bash

#java
JAVA_ARCHIVE=jdk-7u51-linux-x64.gz
#ant
ANT_ARCHIVE=apache-ant-1.9.4-bin.zip
#maven
MAVEN_ARCHIVE=apache-maven-3.2.5-bin.zip
#ssh
SSH_RES_DIR=/vagrant/resources/ssh
RES_SSH_COPYID_ORIGINAL=$SSH_RES_DIR/ssh-copy-id.original
RES_SSH_COPYID_MODIFIED=$SSH_RES_DIR/ssh-copy-id.modified
RES_SSH_CONFIG=$SSH_RES_DIR/config
#RStudio
RSTUDIO_ARCHIVE=rstudio-server-0.98.1103-amd64.deb
RSTUDIO_MIRROR_DOWNLOAD=http://download2.rstudio.org/$RSTUDIO_ARCHIVE
#OpenMPI
OPENMPI_ARCHIVE=openmpi-1.8.8.tar.gz
OPEMMPI_MIRROR_DOWNLOAD=http://www.open-mpi.org/software/ompi/v1.8/downloads/$OPENMPI_ARCHIVE

function resourceExists {
	FILE=/vagrant/resources/$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

function fileExists {
	FILE=$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

#echo "common loaded"
