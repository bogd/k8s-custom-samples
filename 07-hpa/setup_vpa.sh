#!/bin/bash

# https://github.com/kubernetes/autoscaler/tree/master/vertical-pod-autoscaler#installation

git clone https://github.com/kubernetes/autoscaler.git

./autoscaler/vertical-pod-autoscaler/hack/vpa-up.sh
