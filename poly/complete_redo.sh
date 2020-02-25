#!/usr/bin/env bash

./delete_all_minikube.sh
./install_minikube.sh
./minikube_setup.sh

# Check deployment rollout status every 10 seconds (max 10 minutes) until complete.
# obtained from https://www.jeffgeerling.com/blog/2018/updating-kubernetes-deployment-and-waiting-it-roll-out-shell-script
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment.apps/tiller-deploy -n kube-system"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
  $ROLLOUT_STATUS_CMD
  ATTEMPTS=$((attempts + 1))
  sleep 10
done

./get_status.sh
./poly_setup.sh

# Check deployment rollout status every 10 seconds (max 10 minutes) until complete.
# obtained from https://www.jeffgeerling.com/blog/2018/updating-kubernetes-deployment-and-waiting-it-roll-out-shell-script
ATTEMPTS=0
ROLLOUT_STATUS_CMD="kubectl rollout status deployment.apps/polyaxon-polyaxon-api -n polyaxon"
until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
  $ROLLOUT_STATUS_CMD
  ATTEMPTS=$((attempts + 1))
  sleep 10
done

./config_polycli.sh