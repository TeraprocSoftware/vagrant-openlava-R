#!/bin/bash
source "/vagrant/scripts/common.sh"

function setupMesos {
	echo "setting up Mesos"

    /* http://mesos.apache.org/gettingstarted/ */
    apt-get update
    apt-get install -y tar wget git
    apt-get install -y openjdk-7-jdk
    apt-get install -y autoconf libtool
    apt-get -y install build-essential python-dev python-boto libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev
    
    /* http://mesos.apache.org/documentation/latest/configuration/ (/
    cd /usr/local
    git clone https://github.com/apache/mesos.git mesos.git
    cd mesos.git
    git checkout -b 0.28.0 tags/0.28.0
    /bootstrap
    mkdir build
    cd build
    ../configure --prefix=/usr/local/mesos
    make
    make check
    make install

    /* http://www.scala-sbt.org/release/docs/zh-cn/Installing-sbt-on-Linux.html */
    echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
    apt-get update
    apt-get install sbt
    
    /* https://github.com/mesosphere/marathon/tree/releases/1.0 */
    /* https://mesosphere.github.io/marathon/docs/command-line-flags.html */
    cd /usr/local
    git clone https://github.com/mesosphere/marathon.git marathon.git
    cd marathon
    sbt assembly
    ./bin/build-distribution
    
    /* docker run -d -e MYID=1 -e SERVERS=olnode1 --name=zookeeper --net=host --restart=always mesoscloud/zookeeper:3.4.6-ubuntu-14.04 */
    /* ./bin/start --master olnode1:5050 */
}

echo "setup Mesos"
setupMeos
