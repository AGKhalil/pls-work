#!/usr/bin/env bash

set -eo pipefail

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

readonly kf_name="pls-work"
readonly kfctl_download_url="https://github.com/kubeflow/kfctl/releases/download/v1.0.1/kfctl_v1.0.1-0-gf3edb9b_linux.tar.gz"
readonly kfctl_config_url="https://raw.githubusercontent.com/kubeflow/manifests/v1.0-branch/kfdef/kfctl_k8s_istio.v1.0.0.yaml"

info "Download kfctl tarball"
curl -Lo kfctl.tar.gz ${kfctl_download_url}

info "Install kfctl"
tar -xzf kfctl.tar.gz
chmod +x kfctl
sudo mv kfctl /usr/local/bin/kfctl
rm kfctl.tar.gz

#KF_NAME=${kf_name}
