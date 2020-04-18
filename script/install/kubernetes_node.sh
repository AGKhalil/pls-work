#!/usr/bin/env bash

set -eo pipefail

readonly kubeadm_token="${PLSWORK_KUBEADM_TOKEN}"
readonly master="${PLSWORK_KUBERNETES_MASTER}"
readonly master_ip="${PLSWORK_KUBERNETES_MASTER_IP}"
readonly evictionhard_nodefsavailable="${PLSWORK_KUBELET_EVICTIONHARD_NODEFSAVAILABLE}"


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
sudo apt-get install -qy kubelet=1.17.4-00 kubectl=1.17.4-00 kubeadm=1.17.4-00

info "Turn off swap (TODO make sure swap is off after the OS reboot)."
sudo swapoff -a

info "Run kubeadm reset"
sudo kubeadm reset --force

if [ ${master} -eq 1 ]; then
    info "Run kubeadm init."
    sudo kubeadm init --token=${kubeadm_token} --token-ttl=0 --apiserver-advertise-address=${master_ip} --pod-network-cidr=192.168.0.0/16

    info "Prepare kubeconfig."
    mkdir -p $HOME/.kube
    sudo cp -a /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    info "Untaint master node."
    kubectl taint nodes --all node-role.kubernetes.io/master-

    info "Install calico."
    kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml

    info "Install NVIDIA K8s device plugin."
    kubectl apply -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/1.0.0-beta5/nvidia-device-plugin.yml
else
    info "Run kubeadm join."
    sudo kubeadm join --token=${kubeadm_token} --discovery-token-unsafe-skip-ca-verification ${master_ip}:6443
fi

info "Create Kubelet configuration."
cat <<EOF | sudo tee /var/lib/kubelet/config.yaml > /dev/null
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    cacheTTL: 0s
    enabled: true
  x509:
    clientCAFile: /etc/kubernetes/pki/ca.crt
authorization:
  mode: Webhook
  webhook:
    cacheAuthorizedTTL: 0s
    cacheUnauthorizedTTL: 0s
clusterDNS:
- 10.96.0.10
clusterDomain: cluster.local
cpuManagerReconcilePeriod: 0s
evictionPressureTransitionPeriod: 0s
fileCheckFrequency: 0s
healthzBindAddress: 127.0.0.1
healthzPort: 10248
httpCheckFrequency: 0s
imageMinimumGCAge: 0s
kind: KubeletConfiguration
nodeStatusReportFrequency: 0s
nodeStatusUpdateFrequency: 0s
rotateCertificates: true
runtimeRequestTimeout: 0s
staticPodPath: /etc/kubernetes/manifests
streamingConnectionIdleTimeout: 0s
syncFrequency: 0s
volumeStatsAggPeriod: 0s
#
# The content above was generated using:
#
#        kubeadm config print init-defaults --component-configs KubeletConfiguration
#
# Lines below are added manually.
#
evictionHard:
  nodefs.available: "${evictionhard_nodefsavailable}"
EOF

info "Restart kubelet service."
sudo systemctl restart kubelet
