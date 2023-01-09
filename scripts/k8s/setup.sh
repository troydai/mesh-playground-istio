#!/bin/bash

CLUSTER_NAME=mesh-playground-istio

kubectl config use-context "kind-$CLUSTER_NAME"

# Install Istio (https://istio.io/latest/docs/setup/getting-started/#download)

# Set up kubenetes dashboard
kubectl apply -f ./config/k8s/dashboard.yaml
kubectl create serviceaccount -n kubernetes-dashboard admin-user
kubectl create clusterrolebinding \
    -n kubernetes-dashboard \
    admin-user \
    --clusterrole cluster-admin \
    --serviceaccount=kubernetes-dashboard:admin-user

# Set up mesh one
kubectl apply -f ./mesh/one.yml
