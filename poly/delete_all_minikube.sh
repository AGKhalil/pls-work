#!/usr/bin/env bash

minikube stop; minikube delete
rm -r ~/.kube ~/.minikube
sudo rm /usr/local/bin/kubectl /usr/local/bin/minikube
systemctl stop '*kubelet*.mount'
sudo rm -rf /etc/kubernetes/