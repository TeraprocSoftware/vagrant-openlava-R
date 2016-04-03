#!/bin/bash
source "/vagrant/scripts/common.sh"

function setupGo {
	echo "setting up Go"
   
    mkdir -p /usr/local/gowork/src
    mkdir -p /usr/local/gowork/pkg
    mkdir -p /usr/local/gowork/bin
	
    echo export GOROOT=/usr/local/go > /etc/profile.d/go.sh
    echo export GOPATH=/usr/local/gowork >> /etc/profile.d/go.sh
	echo export PATH=\${GOROOT}/bin:\${GOPATH}/bin:\${PATH} >> /etc/profile.d/go.sh
    echo export LD_LIBRARY_PATH=/usr/local/lib:\${LD_LIBRARY_PATH} >> /etc/profile.d/go.sh
    
    . /etc/profile.d/go.sh
    
    /* https://github.com/tools/godep */
    go get github.com/tools/godep
    if resourceExists /vagrant/resources/protobuf-2.6.0.tar.gz; then
		echo "installing protobuf from local file"
	else
		curl -o /vagrant/resources/protobuf-2.6.0.tar.gz -O -L https://protobuf.googlecode.com/svn/rc/protobuf-2.6.0.tar.gz
	fi
    
    tar -xzf /vagrant/resources/protobuf-2.6.0.tar.gz -C /usr/local
    ln -s /usr/local/protobuf-2.6.0 /usr/local/protobuf
    cd /usr/local/protobuf
    ./configure && make install
    
    /* https://github.com/golang/protobuf */
    go get -u -v github.com/golang/protobuf/{proto,protoc-gen-go}
    go get -u -v github.com/minaandrawos/Go-Protobuf-Examples
    
    /* https://github.com/mesosphere/marathon/tree/releases/1.0 */
    /* https://gist.github.com/massenz/e1d88ab715a5fbf174d9 */
    /* http://www.scala-sbt.org/release/docs/zh-cn/Installing-sbt-on-Linux.html */
}

function installGo {
    FILE=/vagrant/resources/$GO_ARCHIVE
	if resourceExists $GO_ARCHIVE; then
		echo "installing Go from local file"
	else
		curl -o $FILE -O -L $GO_MIRROR_DOWNLOAD
	fi
    tar -xzf $FILE -C /usr/local
}

echo "setup Go"
installGo
setupGo
