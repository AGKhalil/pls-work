#!/usr/bin/env bash

set -eo pipefail

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

info "Downloading helm client."
curl -LO https://get.helm.sh/helm-v2.16.3-linux-amd64.tar.gz

info "Unpack downloaded helm tarball."
tar -xzf helm-v2.16.3-linux-amd64.tar.gz

info "Move helm binary to /usr/local/bin."
sudo mv linux-amd64/helm /usr/local/bin/
rm -rf helm-v2.16.3-linux-amd64.tar.gz linux-amd64

info "Crate ServiceAccount for tiller."
kubectl --namespace kube-system create sa tiller

info "Create ClusterRoleBinding for tiller."
kubectl create clusterrolebinding tiller \
    --clusterrole cluster-admin \
    --serviceaccount=kube-system:tiller

info "Install tiller."
helm init --service-account tiller

# TODO Wait for tiller to be installed.

info "Run helm version."
helm version
