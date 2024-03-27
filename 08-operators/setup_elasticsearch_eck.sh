#!/bin/bash

LATEST_VERSION=$(curl -s https://api.github.com/repos/elastic/cloud-on-k8s/releases | jq '.[].tag_name' -r | head -n 1) 

oc create -f https://download.elastic.co/downloads/eck/${LATEST_VERSION#v}/crds.yaml
echo "Waiting for CRDs..."
until kubectl get elasticsearch.elasticsearch ; do date; sleep 1; echo ""; done
oc create -f https://download.elastic.co/downloads/eck/${LATEST_VERSION#v}/operator.yaml
