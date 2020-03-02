#!/usr/bin/env bash

set -eo pipefail

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

# This file is based on https://docs.polyaxon.com/setup/archlinux-kubeadm/#requirements.

info "Configure IPv4 reverse path filtering."
sudo sed -i '/net.ipv4.conf.default.rp_filter/c\net.ipv4.conf.default.rp_filter=1' \
    /etc/sysctl.d/99-sysctl.conf
sudo sed -i '/net.ipv4.conf.all.rp_filter/c\net.ipv4.conf.all.rp_filter=1' \
    /etc/sysctl.d/99-sysctl.conf

info "Verify IPv4 reverse path filtering configuration."
grep '^net.ipv4.conf.default.rp_filter=1$' /etc/sysctl.d/99-sysctl.conf
grep '^net.ipv4.conf.all.rp_filter=1$' /etc/sysctl.d/99-sysctl.conf


info "Enable IPv4 reverse path filtering."
echo 1 | sudo tee /proc/sys/net/ipv4/conf/default/rp_filter > /dev/null
echo 1 | sudo tee /proc/sys/net/ipv4/conf/all/rp_filter > /dev/null
