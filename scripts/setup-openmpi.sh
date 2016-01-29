#!/bin/bash
source "/vagrant/scripts/common.sh"

function installOpenMPI {
	echo "setting up OpenMPI"
	# FILE=/vagrant/resources/$OPENMPI_ARCHIVE
	# if resourceExists $OPENMPI_ARCHIVE; then
	#	echo "install OpenMPI from local file"
	# else
	#	curl -o $FILE -O -L $OPEMMPI_MIRROR_DOWNLOAD
	# fi
	tar -xzf /vagrant/resources/openmpi-1.8.4.tgz -C /usr/local
    ln -s /usr/local/openmpi-1.8.4 /usr/local/openmpi
	#tar -xzf $FILE -C /usr/local
	#ln -s /usr/local/openmpi-1.10.2 /usr/local/openmpi
	#cd /usr/local/openmpi
	#./configure --prefix=/usr/local/openmpi
	#make all
	#make install
	/bin/cp -f /vagrant/resources/openmpi.sh /etc/profile.d/openmpi.sh
	/bin/cp -rf /usr/local/openmpi/lib/* /usr/lib/
}

echo "setup OpenMPI"
installOpenMPI
