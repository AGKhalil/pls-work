#!/usr/bin/env bash

yes | sudo apt-get update
yes | sudo apt-get install apt-transport-https
yes | sudo apt-get upgrade
yes | sudo apt install virtualbox virtualbox-ext-pack

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && sudo chmod +x minikube
sudo install minikube /usr/local/bin/

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.10/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl