
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end
  config.vm.provision :file do |file|
    file.source      = './mysql.cnf'
    file.destination = '/home/ubuntu/mysql.cnf'
  end
  config.vm.provision :file do |file|
    file.source      = './nginx'
    file.destination = '/home/ubuntu/nginx'
  end
  config.vm.provision :file do |file|
    file.source      = './id_rsa'
    file.destination = '/home/ubuntu/.ssh/id_rsa'
  end
  config.vm.provision "shell", path: "./prod_script.sh"
end
