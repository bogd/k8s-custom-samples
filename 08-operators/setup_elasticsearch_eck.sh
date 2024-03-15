#!/bin/bash

oc create -f https://download.elastic.co/downloads/eck/2.11.0/crds.yaml
echo "Waiting for CRDs..."
until kubectl get elasticsearch.elasticsearch ; do date; sleep 1; echo ""; done
oc create -f https://download.elastic.co/downloads/eck/2.11.0/operator.yaml
