#!/bin/bash
source "/vagrant/scripts/common.sh"

function installOpenlava {
	echo "setting up openlava"
    apt-get install -y autoconf tcl tcl-dev automake bison flex libtool intltool xorg-dev libsamplerate-dev libncurses5-dev 

    #tar zxvf openlava-3.0.1.tar.gz
    #cd openlava-3.0.1
    #autoreconf --install
    #./configure --prefix=/opt/openlava-3.0.1
    #make
    #make install
    #cd config
    #cp lsf.conf lsb.hosts lsb.params lsb.queues lsb.users lsf.cluster.openlava lsf.shared lsf.task openlava.csh openlava.setup openlava.sh /opt/openlava/etc/

    # install from deb package
    dpkg -i /vagrant/resources/openlava-3.0-0.x86_64.deb
    #/etc/init.d/openlava stop
    #update-rc.d openlava disable
    #userdel openlava
	. /etc/profile.d/openlava.sh
	localhost=$(hostname)
	
    ln -s /opt/openlava-3.0 /opt/openlava
    sed -i "s/--skip-alias //" /opt/openlava/bin/openmpi-mpirun	
	
    # master node
	if [ $localhost == "olnode1" ]; then
		/bin/cp -f /vagrant/resources/lsf.cluster.openlava /opt/openlava/etc/		
		/bin/cp -f /vagrant/resources/lsb.queues /opt/openlava/etc
		/bin/cp -f /vagrant/resources/lsb.params /opt/openlava/etc
		/bin/cp -f /vagrant/resources/lsb.hosts /opt/openlava/etc
        echo "LSF_ROOT_REX=y" >> /opt/openlava/etc/lsf.conf
        echo "LSF_LIM_IGNORE_CHECKSUM=y" >> /opt/openlava/etc/lsf.conf
		sed -i "s/MASTER_HOSTNAME/olnode1/" /opt/openlava/etc/lsf.cluster.openlava 
		sed -i "s/MASTER_HOSTNAME/olonde1/" /opt/openlava/etc/lsb.hosts
		/opt/openlava/etc/openlava restart
    fi

	# compute host
	if [ $localhost != "olnode1" ]; then
		/bin/cp -f /vagrant/resources/lsf.cluster.openlava /opt/openlava/etc/
		/bin/cp -f /vagrant/resources/lsb.queues /opt/openlava/etc
		/bin/cp -f /vagrant/resources/lsb.params /opt/openlava/etc
		/bin/cp -f /vagrant/resources/lsb.hosts /opt/openlava/etc
	    echo "LIM_COMPUTE_ONLY=y" >> /opt/openlava/etc/lsf.conf
		echo "LSF_ROOT_REX=y" >> /opt/openlava/etc/lsf.conf
		echo "LSF_LIM_IGNORE_CHECKSUM=y" >> /opt/openlava/etc/lsf.conf
		echo "LSF_SERVER_HOSTS=olnode1" >> /opt/openlava/etc/lsf.conf
		# sed -i "s/MASTER_HOSTNAME/$master_hostname/" /opt/openlava/etc/lsf.cluster.openlava 
        # sed -i "s/MASTER_HOSTNAME/$master_hostname/" /opt/openlava/etc/lsb.hosts 
		sed -i "s/MASTER_HOSTNAME/olnode1/" /opt/openlava/etc/lsf.cluster.openlava 
		sed -i "/olnode1/a $localhost   !       !      1      -      -" /opt/openlava/etc/lsf.cluster.openlava
		export LSF_SERVER_HOSTS=olnode1

		/opt/openlava/etc/openlava restart
		/opt/openlava/bin/lsaddhost $localhost
	fi
	
	# /bin/cp -f /vagrant/resources/openmpi-mpirun /opt/openlava/bin
	mkdir /home/openlava/
	chown -R openlava:openlava /home/openlava/
	sed -i 's@^openlava.*@openlava:$6$QyrSBgRo$6uPmKg7nSleT3akUMWGl2kF0A3IMU2GAJUjN8E.pSkWRBjEjrOF122IsyPhrFPJWf.qssuYrJGHAxOG/TGNe5/:16483::::::@g' /etc/shadow
}

echo "setup openlava"
installOpenlava
