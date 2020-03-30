#!/usr/bin/env bash

set -eo pipefail

readonly nfs_dir="${PLSWORK_NFS_DIR}"
readonly nfs_export_host="${PLSWORK_NFS_EXPORT_HOST}"
readonly nfs_server="${PLSWORK_NFS_SERVER}"

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

# See:
# - https://www.kubeflow.org/docs/other-guides/kubeflow-on-multinode-cluster/#nfs-persistent-volumes
# - https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-18-04

info "Install NFS packages."
sudo apt-get -y install nfs-common nfs-kernel-server

info "Create NFS directory."
sudo mkdir -p ${nfs_dir}
sudo chown nobody:nogroup ${nfs_dir}

info "Export NFS directory."
line="${nfs_dir} ${nfs_export_host}(rw,no_root_squash,no_subtree_check)"
set +e
line_cnt=$(grep -cxF "$line" /etc/exports)
set -e
ret=$?
if [ $? -gt 1 ] ; then
    exit ${ret}
fi
if [ ${line_cnt} -eq 0 ] ; then
    echo "Configuring export \"${line}\"."
    echo "$line" | sudo tee -a /etc/exports >/dev/null
    sudo systemctl restart nfs-kernel-server
else
    echo "Export \"${line}\" already configured."
fi

info "Install nfs-client-provisioner."
helm install \
    --name nfs-client-provisioner \
    --set nfs.server=${nfs_server} \
    --set nfs.path=${nfs_dir} \
    --set storageClass.name=nfs \
    --set storageClass.defaultClass=true \
    stable/nfs-client-provisioner
