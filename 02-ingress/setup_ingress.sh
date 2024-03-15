#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.0-beta.3/deploy/static/provider/baremetal/deploy.yaml

# For k8s 1.22, there seem to be some issues with the releases?
# https://github.com/kubernetes/ingress-nginx/issues/7448
# https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.0-beta.3/deploy/static/provider/baremetal/deploy.yaml
# For now, it might need kubectl delete -A validatingwebhookconfiguration.admissionregistration.k8s.io/ingress-nginx-admission

# Workaround for webhook validation failures (if patch job fails):
# 
# CA_DATA=$(kubectl get secret -n ingress-nginx ingress-nginx-admission -o jsonpath={.data.ca})
# kubectl patch validatingwebhookconfiguration ingress-nginx-admission --type "json" -p "[{\"op\": \"add\", \"path\":\"/webhooks/0/clientConfig/caBundle\", \"value\": \"$CA_DATA\"}]"

kubectl patch -n ingress-nginx svc ingress-nginx-controller -p '{"spec":{"ports":[{"port":80, "nodePort":31080}, {"port":443, "nodePort":31443}]}}'


# Not mandatory, but recommended:
# https://kubernetes.github.io/ingress-nginx/deploy/
# The first time the ingress controller starts, two Jobs create the SSL Certificate used by the admission webhook. 
# For this reason, there is an initial delay of up to two minutes until it is possible to create and validate Ingress definitions.
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
