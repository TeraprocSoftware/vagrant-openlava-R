export OPENMPI_HOME=/usr/local/openmpi
export LD_LIBRARY_PATH=${OPENMPI_HOME}/lib
export PATH=${OPENMPI_HOME}/bin:${PATH}
export OMPI_MCA_btl_tcp_if_include=eth1
