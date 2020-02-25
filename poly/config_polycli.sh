#!/usr/bin/env bash

export POLYAXON_IP=$(minikube ip)
echo POLYAXON_IP
export POLYAXON_PORT=$(kubectl get --namespace polyaxon -o jsonpath="{.spec.ports[0].nodePort}" services polyaxon-polyaxon-api)
echo POLYAXON_PORT
echo http://$POLYAXON_IP:$POLYAXON_PORT
polyaxon config set --host=$POLYAXON_IP --port=$POLYAXON_PORT
polyaxon version