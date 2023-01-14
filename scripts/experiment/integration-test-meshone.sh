#!/bin/bash

echo "> ---"
echo "> Executing in $POD"
echo "> ---"

kubectl exec -n meshone deployment/beacon-alpha-deployment -- /opt/bin/grpcurl -plaintext beacon-alpha:8080 grpcbeacon.Beacon/Signal
kubectl exec -n meshone deployment/beacon-alpha-deployment -- /opt/bin/grpcurl -plaintext beacon-beta:8080 grpcbeacon.Beacon/Signal
