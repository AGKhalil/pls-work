#!/usr/bin/env bash

set -eo pipefail

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

# This file is based on https://docs.polyaxon.com/setup/archlinux-kubeadm.

info "Add polyaxon repository to helm."
helm repo add polyaxon https://charts.polyaxon.com
helm repo update polyaxon

info "Create polyaxon namespace."
kubectl create namespace polyaxon

info "Create polyaxon config."
cat <<EOF | tee /tmp/polyaxon-config.yaml
ingerss:
   enabled: false
rbac:
   enabled: true
ssl:
  enabled: false
user:
  username: root
  email: root@polyaxon.local
  password: rootpassword
serviceType: NodePort
EOF

info "Install polyaxon chart."
helm install polyaxon/polyaxon \
    --name=polyaxon \
    --namespace=polyaxon \
    -f /tmp/polyaxon-config.yaml
