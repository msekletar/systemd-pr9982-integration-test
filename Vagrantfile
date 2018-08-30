Vagrant.configure("2") do |config|
  config.vm.box = "fedora/28-cloud-base"
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.cpus = 2
    vb.memory = 1024

    # add storage controller
    controller = "SATA"
    vb.customize ["storagectl", :id, "--name", controller, "--add", "sata"]

    # add crypt device
    disk = "./crypt-disk.vdi"
    vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 100] unless File.exists?(disk)
    vb.customize ['storageattach', :id,  '--storagectl', controller, '--port', 0, '--device', '0', '--type', 'hdd', '--medium', disk]

    # add keydev
    disk = './passwd-disk.vdi'
    vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 10] unless File.exists?(disk)
    vb.customize ['storageattach', :id,  '--storagectl', controller, '--port', 1, '--device', '0', '--type', 'hdd', '--medium', disk]
  end

  config.vm.provision :shell, path: 'setup-luks.sh'
end
