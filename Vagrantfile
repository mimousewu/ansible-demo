Vagrant.configure(2) do |config|
  config.vm.box = "bento/centos-7.4"

  config.vm.define :vagrant
  config.vm.provider :virtualbox do |v|
      v.memory = 8192
      v.cpus = 2
  end

  config.ssh.username = "root"
  config.ssh.password = "vagrant"
  config.ssh.forward_x11 = true
end
