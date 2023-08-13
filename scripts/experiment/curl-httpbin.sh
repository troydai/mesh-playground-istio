#!/bin/bash

NODE_NAME=istio-playground-control-plane
INGRESS_IP=$(kubectl get svc istio-ingressgateway -nistio-system -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

docker exec $NODE_NAME curl -s -I -HHost:httpbin.example.com http://$INGRESS_IP:80/get
