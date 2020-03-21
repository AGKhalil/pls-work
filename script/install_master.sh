#!/usr/bin/env bash

set -eo pipefail

readonly dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

bold() {
    echo "$(tput bold)$1$(tput sgr0)"
}

readonly master_files=(
"install/apt.sh"
"install/docker.sh"
"install/kubernetes_master.sh"
"install/helm.sh"
"install/kubernetes_master_ingress.yaml"
"install/polyaxon_cert_manager.sh"
"install/polyaxon_rp_filtering.sh"
"install/polyaxon.sh"
)

for file in "${master_files[@]}"; do
    echo
    bold "##############################################################################"
    bold "    ${file}"
    bold "##############################################################################"
    echo
    ${dir}/${file}
done

