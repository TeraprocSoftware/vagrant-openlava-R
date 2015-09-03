#!/bin/bash
source "/vagrant/scripts/common.sh"

function installLocalRStudio {
	echo "installing RStudio from local file"
}

function installRemoteRStudio {
	echo "installing RStudio"
	curl -o /vagrant/resources/$RSTUDIO_ARCHIVE -O -L $RSTUDIO_MIRROR_DOWNLOAD
}

function installRStudio {
	if resourceExists $RSTUDIO_ARCHIVE; then
		installLocalRStudio
	else
		installRemoteRStudio
	fi

    apt-get install -y gdebi-core
    apt-get install -y libapparmor1 # Required only for Ubuntu, not Debian

    gdebi --n /vagrant/resources/$RSTUDIO_ARCHIVE

	# autoload sample codes
	# tar -xvf /vagrant/resources/rstudio-user-env.tar -C /root
    # sed -i "s/teraproc04102/root/g" /root/.rstudio/suspended-session/environment_vars
    # chown -Rf demo:demo /home/demo
	# set LD_LIBRARY_PATH to rstudio server 
    cp -f /vagrant/resources/rserver.conf /etc/rstudio/rserver.conf
    # set OL path for R Studio
    cp -f /vagrant/resources/Rprofile.site /etc/R/Rprofile.site
}

echo "setup RStudio"
installRStudio