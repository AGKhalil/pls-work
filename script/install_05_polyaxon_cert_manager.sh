#!/usr/bin/env bash

set -eo pipefail

cert_manager_version="0.13.1"

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

info "Skip cert-manager installation."
exit 0

# This file is based on:
# - https://docs.polyaxon.com/setup/archlinux-kubeadm/#requirements
# - https://docs.polyaxon.com/setup/archlinux-kubeadm/#install-cert-manager

info "Install cert-manager CRDs."
kubectl apply --validate=false -f \
    https://raw.githubusercontent.com/jetstack/cert-manager/v${cert_manager_version}/deploy/manifests/00-crds.yaml

info "Create cert-manager namespace."
kubectl create namespace cert-manager

info "Add jetstack repository to helm (for cert-manager)."
helm repo add jetstack https://charts.jetstack.io
helm repo update jetstack

info "Install cert-manager chart."
helm install \
    --name cert-manager \
    --namespace cert-manager \
    --version v${cert_manager_version} \
    jetstack/cert-manager

info "Wait for cert-manager to be ready."
while true; do
    sleep 2
    total=$(kubectl get pod --no-headers -n cert-manager | wc -l)
    ready=$(kubectl get pod --no-headers -n cert-manager --field-selector='status.phase=Running' | wc -l)
    if [ $ready -eq 3 ]; then
        echo "Ready."
        break
    fi
    if [ $total -lt 3 ]; then
        echo "Still waiting for pods. $total out of 3 created."
        continue
    fi
    if [ $total -gt 3 ]; then
        echo "Error: Want max 3 pods but got $total." >&2
        echo $out >&2
        exit 1
    fi
    echo "Still waiting for pods to be ready. $ready out of $total ready."
done

# TODO Set email for the letsencrypt issuer.
info "Create cert-manager Issuer."
cat <<EOF | tee /tmp/letsencrypt-issuer.yaml
apiVersion: cert-manager.io/v1alpha2
kind: Issuer
metadata:
  name: letsencrypt
  namespace: default
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    #server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: letsencrypt
    #solvers:
    #- http01:
    #    ingress:
    #      class: nginx
EOF
kubectl apply -f /tmp/letsencrypt-issuer.yaml
rm /tmp/letsencrypt-issuer.yaml
