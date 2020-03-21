#!/usr/bin/env bash

set -eo pipefail

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

# This script is based on
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker.

info "Uninstall existing docker packages."
for pkg in docker docker-engine docker.io; do
    if [ sudo dpkg --status $pkg &> /dev/null ]; then
        sudo apt-get --yes --purge remove $pkg
    fi
done

info "Add Docker's official GPG key."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

info "Add Docker apt repository."
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

info "Update apt-get."
sudo apt-get update

info "Install Docker CE."
sudo apt-get install -y \
    containerd.io=1.2.10-3 \
    docker-ce=5:19.03.4~3-0~ubuntu-$(lsb_release -cs) \
    docker-ce-cli=5:19.03.4~3-0~ubuntu-$(lsb_release -cs)

info "Create docker daemon configuration."
cat <<EOF | sudo tee /etc/docker/daemon.json > /dev/null
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
}
EOF

info "Create systemd docker directory."
sudo mkdir -p /etc/systemd/system/docker.service.d

info "Reload systemd services."
sudo systemctl daemon-reload
info "Restart docker service."
sudo systemctl restart docker
info "Enable docker service."
sudo systemctl enable docker
