#!/usr/bin/env bash

set -eo pipefail

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

# This file is based on https://docs.polyaxon.com/setup/archlinux-kubeadm.

POLYAXON_PASSWORD=my_password
POLYAXON_SERVER=my_server_name
DOMAIN=my.domain.com
LOCAL_IP=192.168.0.2
