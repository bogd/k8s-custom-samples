#!/bin/bash

echo "Installing metrics server"

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo "Patching metrics server for insecure TLS"

# Required for default kubeadm config - see links for details and workarounds!
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/troubleshooting-kubeadm/#cannot-use-the-metrics-server-securely-in-a-kubeadm-cluster
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/#kubelet-serving-certs
kubectl -n kube-system patch deployment metrics-server --type=json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls" }]'
