# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Docs: https://docs.vagrantup.com.
  # Boxes: https://vagrantcloud.com/search.

  config.vm.box = "ubuntu/bionic64"

  # Share an additional folder to the guest VM.
  #config.vm.synced_folder "../path_on_host", "/path_on_guest"

  # Provider-specific configuration.
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = "8192"
  end

  # View the documentation for the provider you are using for more
  # information on available options.

  config.vm.provision "shell", inline: $script

  config.vm.define "alpha" do |alpha|
    alpha.vm.network "private_network", ip: "10.70.26.96"

    # Port forwarding. The third argument only allows access via 127.0.0.1 to
    # disable public access.
    alpha.vm.network "forwarded_port", guest: 31811, host: 8080, host_ip: "127.0.0.1"
  end

  config.vm.define "zeta" do |zeta|
    zeta.vm.network "private_network", ip: "10.70.26.99"
  end
end


$script = <<-'SCRIPT'
cat <<EOF > /home/vagrant/.bashrc
prompt_color() { [ \$? -eq 0 ] && echo -n "32" || echo -n "31" ; }
PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;\$(prompt_color)m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '

alias k=kubectl
EOF
SCRIPT
