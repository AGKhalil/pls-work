#!/usr/bin/env bash

minikube start --vm-driver virtualbox --cpus 4 --memory 8192 --disk-size=40g --kubernetes-version v1.15.10

sudo wget https://get.helm.sh/helm-v2.16.3-linux-amd64.tar.gz
sudo tar -zxvf helm-v2.16.3-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
sudo rm -r helm-v2.16.3-linux-amd64.tar.gz linux-amd64
kubectl --namespace kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller