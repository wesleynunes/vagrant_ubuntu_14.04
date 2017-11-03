Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.hostname = "trusty"
    # config.vm.network :forwarded_port, guest: 80, host: 8080
    # config.vm.network "forwarded_port", guest: 3306, host: 3306
    config.vm.network :private_network, ip: "192.168.33.82"  
    config.vm.synced_folder("./", "/var/www/html", :nfs => true)
    config.vm.provider "virtualbox" do |machine|
    	machine.memory = 1024
        machine.cpus = 1
    	machine.name = "trusty"
    end
    config.vm.provision :shell, path: "setup.sh"
end



