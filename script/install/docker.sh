#!/usr/bin/env bash

set -eo pipefail

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

# Based on:
#
# - https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker
# - https://github.com/NVIDIA/k8s-device-plugin#preparing-your-gpu-nodes

info "Uninstall existing docker packages."
for pkg in docker docker-engine docker.io; do
    set +e
    sudo dpkg --status $pkg &> /dev/null
    ret=$?
    set -e
    if [ $ret -eq 0 ]; then
        sudo apt-get remove --yes --purge $pkg
    fi
done

info "Add Docker's official GPG key."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

info "Add Docker apt repository."
sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

info "Add nvidia-docker GPG key."
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -

info "Add nvidia-docker repository"
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

info "Update apt-get."
sudo apt-get update

info "Install Docker CE."
sudo apt-get install -y \
    containerd.io=1.2.10-3 \
    docker-ce=5:19.03.4~3-0~ubuntu-$(lsb_release -cs) \
    docker-ce-cli=5:19.03.4~3-0~ubuntu-$(lsb_release -cs)

info "Install nvidia-docker2"
sudo apt-get install -y nvidia-docker2

info "Create docker daemon configuration."
cat <<EOF | sudo tee /etc/docker/daemon.json > /dev/null
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
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
