#!/usr/bin/env bash

kubectl create namespace polyaxon
helm repo add polyaxon https://charts.polyaxon.com
helm repo update
helm install polyaxon/polyaxon --name=polyaxon --namespace=polyaxon -f polyaxon_config.yml
