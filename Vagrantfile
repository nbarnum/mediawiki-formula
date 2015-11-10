# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # config.vm.box = "rubicon/ubuntu1404-salt"
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_check_update = true

  config.vm.hostname = "mediawiki-test"
  # config.vm.network "private_network", ip: "172.28.128.11"

  config.vm.synced_folder 'roots/salt', '/srv/salt'
  config.vm.synced_folder 'roots/pillar', '/srv/pillar'
  config.vm.synced_folder '.', '/srv/formulas/mediawiki-formula'

  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    apt-get -y purge ruby1.8
  SHELL

  config.vm.provision :salt do |salt|
    salt.minion_config = 'minion'
    salt.run_highstate = true
    salt.verbose = true
    salt.bootstrap_options = '-F -c /tmp/ -P'
  end
end
