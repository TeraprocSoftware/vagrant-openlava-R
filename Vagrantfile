Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	numNodes = 3
	r = numNodes..1
	(r.last).upto(r.first).each do |i|
		config.vm.define "olnode#{i}" do |node|
			node.vm.box = "ubuntu"
			node.vm.box_url = "https://oss-binaries.phusionpassenger.com/vagrant/boxes/latest/ubuntu-14.04-amd64-vbox.box"
			node.vm.provider "virtualbox" do |v|
			    v.name = "olnode#{i}"
			    v.customize ["modifyvm", :id, "--memory", "1536"]
			    if i == 1
			        v.customize ["modifyvm", :id, "--memory", "2048"]
			    end
			end
			if i < 10
				node.vm.network :private_network, ip: "10.211.59.10#{i}"
			else
				node.vm.network :private_network, ip: "10.211.59.1#{i}"
			end
			node.vm.hostname = "olnode#{i}"
			node.vm.provision "shell", path: "scripts/setup-ubuntu.sh"
			node.vm.provision "shell", path: "scripts/setup-ubuntu-ntp.sh"
			node.vm.provision "shell" do |s|
				s.path = "scripts/setup-ubuntu-hosts.sh"
				s.args = "-t #{numNodes}"
			end
			# node.vm.provision "shell", path: "scripts/setup-java.sh"
            node.vm.provision "shell", path: "scripts/setup-go.sh"
			node.vm.provision "shell", path: "scripts/setup-openmpi.sh"
			node.vm.provision "shell", path: "scripts/setup-R.sh"
			node.vm.provision "shell", path: "scripts/setup-openlava.sh"
			if i == 1
				node.vm.provision "shell", path: "scripts/setup-RStudio.sh"
			end
		end
	end
end