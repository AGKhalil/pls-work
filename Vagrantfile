# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Docs: https://docs.vagrantup.com.
  # Boxes: https://vagrantcloud.com/search.

  config.vm.box = "ubuntu/bionic64"
  config.vm.network "private_network", ip: "10.70.26.96"

  # Port forwarding. The third argument only allows access via 127.0.0.1 to
  # disable public access.
  #config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Share an additional folder to the guest VM.
  #config.vm.synced_folder "../path_on_host", "/path_on_guest"

  # Provider-specific configuration.
  #config.vm.provider "virtualbox" do |vb|
  #  vb.memory = "1024"
  #end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  config.vm.provision "shell", inline: $script
end


$script = <<-'SCRIPT'
cat <<EOF > /home/vagrant/.bashrc
prompt_color() { [ \$? -eq 0 ] && echo -n "32" || echo -n "31" ; }
PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;\$(prompt_color)m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '
EOF
SCRIPT
