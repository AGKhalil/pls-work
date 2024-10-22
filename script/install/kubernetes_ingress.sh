#!/usr/bin/env bash

set -eo pipefail

readonly ingress_http_port="${PLSWORK_INGRESS_HTTP_PORT}"
readonly ingress_https_port="${PLSWORK_INGRESS_HTTPS_PORT}"

info() {
    echo "$(tput bold)====> $1$(tput sgr0)"
}

info "Skip ingress installation."
exit 0

info "Install ingress-nginx."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.30.0/deploy/static/mandatory.yaml

info "Create ingress Service."
cat <<EOF | sudo tee /tmp/ingress-nodeport-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: ingress-nginx
  namespace: ingress-nginx
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
spec:
  type: NodePort
  ports:
    - name: http
      port: ${ingress_http_port}
      targetPort: 80
      protocol: TCP
    - name: https
      port: ${ingress_https_port}
      targetPort: 443
      protocol: TCP
  selector:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
EOF
kubectl apply -f /tmp/ingress-nodeport-service.yaml
rm /tmp/ingress-nodeport-service.yaml
