#!/usr/bin/env bash

set -eo pipefail

readonly master="${PLSWORK_KUBERNETES_MASTER}"

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

if [ $master -eq 1 ] ; then
    info "Crate ServiceAccount for tiller."
    kubectl --namespace kube-system create sa tiller

    info "Create ClusterRoleBinding for tiller."
    kubectl create clusterrolebinding tiller \
        --clusterrole cluster-admin \
        --serviceaccount=kube-system:tiller

    if [ ${master} -eq 1 ] ; then
        info "Install tiller."
        helm init --service-account tiller --wait
    fi

    info "Run helm version."
    helm version
else
    info "Run helm version --client."
    helm version --client
fi

