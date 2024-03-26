#!/bin/bash

LATEST_VERSION=$(curl -s https://api.github.com/repos/kubernetes/ingress-nginx/releases | jq '.[].tag_name|select(. | startswith("controller-"))' -r | head -n 1)

echo "Installing Nginx ingress controller - found latest release $LATEST_VERSION"

#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.3.0/deploy/static/provider/baremetal/deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/$LATEST_VERSION/deploy/static/provider/baremetal/deploy.yaml

echo "Patching nodePorts for ingress controller"
kubectl patch -n ingress-nginx svc ingress-nginx-controller -p '{"spec":{"ports":[{"port":80, "nodePort":31080}, {"port":443, "nodePort":31443}]}}'

echo -n "Waiting up to 120s for ingress controller to start..."

# Not mandatory, but recommended:
# https://kubernetes.github.io/ingress-nginx/deploy/
# The first time the ingress controller starts, two Jobs create the SSL Certificate used by the admission webhook. 
# For this reason, there is an initial delay of up to two minutes until it is possible to create and validate Ingress definitions.
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

echo "done!"

