# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "centos5"
  config.vm.forward_port 3000, 3001
  config.vm.customize ["modifyvm", :id, "--memory", 1024]

  # Puppet
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
  end
end
