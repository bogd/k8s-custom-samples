#!/bin/bash

cat ~/.kube/config | grep client-certificate-data | head -n 1 | sed -E 's/^.*client-certificate-data: (.*)$/\1/' | base64 -d | openssl x509 -noout -text