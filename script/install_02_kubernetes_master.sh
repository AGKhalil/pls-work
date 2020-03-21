#!/usr/bin/env bash

set -eo pipefail

kubeadm_token="h3jajt.vz9z4uxxrw310p45" # Generated with `kubeadm token generate`.
master_ip="10.70.26.96"

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

info "Add Google apt key."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

info "Add kubernetes package list."
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

info "Run apt-get update."
sudo apt-get update

info "Install kubelet/kubectl/kubeadm."
sudo apt-get install -qy kubelet=1.17.3-00 kubectl=1.17.3-00 kubeadm=1.17.3-00

# TODO Make sure swap is off after OS reboot.
info "Turn off swap (TODO make sure swap is off after the OS reboot)."
sudo swapoff -a

info "Run kubeadm reset"
sudo kubeadm reset --force

info "Run kubeadm init."
sudo kubeadm init --apiserver-advertise-address=${master_ip} --pod-network-cidr=192.168.0.0/16

info "Prepare kubeconfig."
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

info "Untaint master node."
kubectl taint nodes --all node-role.kubernetes.io/master-

info "Install calico."
kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml
