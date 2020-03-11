#!/usr/bin/env bash

set -eo pipefail

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

helm install stable/nfs-server-provisioner

## Based on:
## - https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-18-04
#
#info "Installing NFS server."
#sudo apt-get install nfs-kernel-server
#
## TODO on the client
#sudo apt install nfs-common
