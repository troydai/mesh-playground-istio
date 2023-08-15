#!/bin/bash

CONTROL_CLUSTER_NAME=control
REMOTE_CLUSTER_NAME=remote
CLUSTERS_NAMES=( "$CONTROL_CLUSTER_NAME" "$REMOTE_CLUSTER_NAME" )

for CLUSTER in "${CLUSTERS_NAMES[@]}"; do
    echo "Creating cluster $CLUSTER"
    kind create cluster --config kind/cluster.yml -n $CLUSTER
    kubectl apply -f kind/metallb-native.yaml --context kind-$CLUSTER
    kubectl wait \
        --namespace metallb-system \
        --for=condition=ready pod \
        --selector=app=metallb \
        --timeout=90s \
        --context kind-$CLUSTER
    kubectl apply -f kind/metallb-config.yaml --context kind-$CLUSTER
done
