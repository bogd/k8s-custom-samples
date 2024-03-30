#!/bin/bash

# Creates a user - needs to be run on a k8s control plane node, with the CA available
# For generating a user from another machine, we need to submit the CSR for signing: https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#approval-rejection

openssl genrsa -out bogd.key 2048
openssl req -new -sha256 -key bogd.key -out bogd.csr -subj "/CN=bogd/O=pod-viewers/O=user-00-admins"
openssl x509 -req -days 365 -in bogd.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out bogd.final.pem

cp ~/.kube/config ~/.kube/config-backup-$(date +%F)

kubectl config set-credentials bogd --client-key=bogd.key --client-certificate=bogd.final.pem --embed-certs=true
kubectl config set-context bogd --cluster=kubernetes --user=bogd

