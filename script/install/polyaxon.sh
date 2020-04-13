#!/usr/bin/env bash

set -eo pipefail

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

# This file is based on https://docs.polyaxon.com/setup/archlinux-kubeadm.

info "Install Polyaxon CLI."
pip install --quiet --upgrade polyaxon-cli

info "Add Polyaxon repository to helm."
helm repo add polyaxon https://charts.polyaxon.com
helm repo update

info "Create Polyaxon namespace."
set +e
kubectl get namespace polyaxon &>/dev/null
ret=$?
set -e
if [[ $ret -ne 0 ]] ; then
    kubectl create namespace polyaxon
fi

info "Create Polyaxon config."
cat <<EOF | tee /tmp/polyaxon-config.yaml
dirs:
  nvidia:
    bin: "/usr/bin"
    lib: "/usr/lib/x86_64-linux-gnu"
    libcuda: "/usr/lib/x86_64-linux-gnu/libcuda.so.1"
ingress:
   enabled: false
rbac:
   enabled: true
ssl:
  enabled: false
user:
  username: root
  email: root@polyaxon.local
  password: rootpassword
EOF

info "Validate Polyaxon config."
polyaxon admin deploy -f /tmp/polyaxon-config.yaml --check

info "Checking if Polyaxon is already installed."
polyaxon_installed=$(helm ls -q '^polyaxon$' | wc -l)

if [[ $polyaxon_installed -eq 0 ]] ; then
    info "Install Polyaxon chart."
    helm install polyaxon/polyaxon --name=polyaxon --namespace=polyaxon -f /tmp/polyaxon-config.yaml
else
    info "Upgrade Polyaxon chart."
    helm upgrade polyaxon polyaxon/polyaxon -f /tmp/polyaxon-config.yaml
fi
